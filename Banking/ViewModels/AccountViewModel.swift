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
    
    @Published var search: String = ""
    @Published var faqs = [FAQModel]()
    @Published var page = 0
    
    @Published var info: UserInfoViewModel?
    
    private var cancellableSet: Set<AnyCancellable> = []
    var manager: UserServiceProtocol
    init(manager: UserServiceProtocol = UserSerive.shared) {
        self.manager = manager
        super.init()
        
        $search
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { (text) in
                self.page = 0
                self.faqs.removeAll(keepingCapacity: false)
                Task { @MainActor [weak self] in
                    self?.getFAQs(searchText: text)
                }
            }.store(in: &cancellableSet)
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
    
    @MainActor func updateInfo(name: String, email: String?) {
        loading = true
        Task {
            
            let result = await manager.updateAccountInfo(userID: userID, name: name, email: email)
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                self.localName = name
                NotificationCenter.default.post(name: Notification.Name(NotificationName.infoUpdated.rawValue), object: nil)
            }
            if !Task.isCancelled {
                loading = true
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
    
    @MainActor func getFAQs(searchText: String = "") {
        loading = true

        Task {
            do {
                let result = try await manager.fetchFaqs(query: searchText, page: page)
                self.faqs.append(contentsOf: result.hits)
                self.page += 1
            } catch let error as NetworkError {
                self.makeNetworkAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loading = false
            }
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
