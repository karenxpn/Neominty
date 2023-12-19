//
//  NotificationsViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class NotificationsViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var notifications = [NotificationModelViewModel]()
    // add pagination
    @Published var lastNotification: QueryDocumentSnapshot?

    
    var manager: NotificationsServiceProtocol
    init(manager: NotificationsServiceProtocol = NotificationsService.shared) {
        self.manager = manager
    }
    
    @MainActor func getNotifications() {
        loading = true
        Task {
            let result = await manager.fetchNotifications(userID: userID, lastDocSnapshot: lastNotification)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let response):
                self.notifications.append(contentsOf: response.0.map(NotificationModelViewModel.init))
                self.lastNotification = response.1
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func markAsRead() {
        Task {
            let result = await manager.markAllAsRead(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                for i in 0..<notifications.count {
                    self.notifications[i].read = true
                }
            }
        }
    }
}
