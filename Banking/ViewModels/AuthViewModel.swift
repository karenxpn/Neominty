//
//  AuthViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI
import FirebaseAuth

final class AuthViewModel: AlertViewModel, ObservableObject {
    
    @Published var country: String = "AM"
    @Published var code: String = "374"
    @Published var phoneNumber: String = ""
    @Published var flag: String = "🇦🇲"
    @Published var OTP: String = ""
    
    @Published var loading: Bool = false
    
    @Published var navigate: Bool = false
    
    @Published var introductionPages = [IntroductionModel]()

    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var manager: AuthServiceProtocol
    
    init(manager: AuthServiceProtocol = AuthService.shared) {
        self.manager = manager
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
        }
    }
    
    @MainActor func sendVerificationCode(send: Bool = true) {
        loading = true
        Task {
            let result = await manager.sendVerificationCode(phone: "+\(code)\(phoneNumber)")
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                if send {
                    self.navigate = true
                } else {
                    break
                }
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func checkVerificationCode() {
        loading = true
        Task {
            
            let result = await manager.checkVerificationCode(code: OTP)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success( _):
                break
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
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
