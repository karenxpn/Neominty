//
//  AuthViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import LocalAuthentication

final class AuthViewModel: AlertViewModel, ObservableObject {
    
    @AppStorage("userID") var userID: String = ""
    @AppStorage("phoneNumber") var localPhone: String = ""
    @AppStorage("biometricEnabled") var biometricEnabled: Bool = false
    @Published var country: String = "AM"
    @Published var code: String = "374"
    @Published var phoneNumber: String = ""
    @Published var flag: String = "🇦🇲"
    @Published var OTP: String = ""
    
    @Published var loading: Bool = false
    
    @Published var navigate: Bool = false
    
    @Published var introductionPages = [IntroductionModel]()
    
    @Published var authState: AuthenticationState = .notDetermind
    @Published var passcode: String = ""
    @Published var passcodeConfirm: String = ""
    
    @Published var passcodeToBeMatched: String = ""
    
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var path: [ViewPaths] = []
    
    var manager: AuthServiceProtocol
    var userManager: UserServiceProtocol
    
    init(manager: AuthServiceProtocol = AuthService.shared,
         userManager: UserServiceProtocol = UserSerive.shared) {
        self.manager = manager
        self.userManager = userManager
    }
    
    var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
            self.localPhone = user?.phoneNumber ?? ""
        }
    }
    
    @MainActor func sendVerificationCode(send: Bool = true) {
        loading = true
        Task {
            let result = await manager.sendVerificationCode(phone: "\(localPhone.isEmpty ? "+\(code)\(phoneNumber)" : localPhone)")
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                if send {
                    self.navigate = true
                    self.path.append(ViewPaths.verifyPhoneNumber)
                } else {
                    break
                }
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func checkVerificationCode(auth: Bool = true) {
        loading = true
        Task {
            
            let result = await manager.checkVerificationCode(code: OTP)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(let uid):
                if auth {
                    self.userID = uid
                } else {
                    self.path.append(ViewPaths.setPasscode)
                }
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func getIntroductionPages() {
        loading = true
        Task {
            
            let result = await manager.fetchIntroduction()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(let intro):
                self.introductionPages = intro
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func checkPinExistence() {
        loading = true
        print("checking pin existence")
        Task {
            let result = await userManager.checkPinExistence(userID: userID)
            switch result {
            case .failure(_):
                self.authState = .setPasscode
            case .success(let pass):
                self.authState = .enterPasscode
                self.passcodeToBeMatched = pass
                if self.biometricEnabled {
                    self.biometricAuthentication()
                }
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func storePin() {
        loading = true
        Task {
            
            let result = await userManager.storePin(userID: userID, pin: passcodeConfirm)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                self.passcodeToBeMatched = self.passcode
                self.authState = .enterPasscode
                self.passcode = ""
                self.passcodeConfirm = ""
                self.path.append(ViewPaths.enableBiometric)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    func biometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Confirm your fingerprint"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    DispatchQueue.main.async {
                        self.biometricEnabled = true
                        self.authState = .authenticated
                        self.path = []
                    }
                } else {
                    print(authenticationError)
                    DispatchQueue.main.async {
                        self.authState = .enterPasscode
                        self.path = []
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.biometricEnabled = false
                self.authState = .enterPasscode
                self.path = []
            }
        }
        
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
