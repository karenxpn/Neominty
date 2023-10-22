//
//  AccountViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import Foundation
import Combine
import SwiftUI

class AccountViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    @AppStorage("fullName") var localName: String = ""

    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var receiveNotifications: Bool = false
    @Published var receiveEmails: Bool = false
    
    @Published var info: UserInfoViewModel?
    
    private var cancellableSet: Set<AnyCancellable> = []
    var manager: UserServiceProtocol
    init(manager: UserServiceProtocol = UserSerive.shared) {
        self.manager = manager
    }
    
    
    @MainActor func getAccountInfo() {
        loading = true
        Task {
            
            let result = await manager.fetchAccountInfo(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let info):
                self.info = UserInfoViewModel(model: info)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func updateInfo(name: String) {
        loading = true
        Task {
            
            let result = await manager.updateAccountInfo(userID: userID, name: name)
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                self.localName = name
                NotificationCenter.default.post(name: Notification.Name(NotificationName.infoUpdated.rawValue), object: nil)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func updateEmail(email: String) {
        loading = true
        Task {
            
            let result = await manager.updateEmail(userID: userID, email: email)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name(NotificationName.emailUpdated.rawValue), object: nil)
            }
            
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func getPreferences() {
        loading = true
        Task {
            
            let result = await manager.fetchUserPreferences(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let preferences):
                self.receiveEmails = preferences.email_notifications
                self.receiveNotifications = preferences.push_notifications
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func updateNotificationPreference(receive: Bool) {
        Task {
            let _ = await manager.updateNotificationsPreferences(userID: userID, receive: receive)
        }
    }
    
    @MainActor func updateEmailPreference(receive: Bool) {
        Task {
            let _ = await manager.updateEmailPreferences(userID: userID, receive: receive)
        }
    }
    
    @MainActor func updateAvatar(image: Data) {
        Task {
            let result = await manager.updateAvatar(userID: userID, image: image)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                break
            }
        }
    }
}
