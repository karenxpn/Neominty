//
//  NotificationsViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.23.
//

import Foundation
class NotificationsViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var notifications = [NotificationModelViewModel]()
    // add pagination
    @Published var page: Int = 0
    
    var manager: NotificationsServiceProtocol
    init(manager: NotificationsServiceProtocol = NotificationsService.shared) {
        self.manager = manager
    }
    
    @MainActor func getNotifications() {
        loading = true
        Task {
            let result = await manager.fetchNotifications()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let notifications):
                self.notifications = notifications.map(NotificationModelViewModel.init)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
