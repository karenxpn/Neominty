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
    
    @Published var country: String = "US"
    @Published var code: String = "1"
    @Published var phoneNumber: String = ""
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
    
    @MainActor func sendVerificationCode(phone: String) {
        loading = true
        Task {
            let result = await manager.sendVerificationCode(phone: phone)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &alertMessage, alert: &showAlert)
            case .success(()):
                self.navigate = true
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func checkVerificationCode(code: String) {
        loading = true
        Task {
            
            let result = await manager.checkVerificationCode(code: code)
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
