//
//  NotificationsService.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.23.
//

import Foundation
protocol NotificationsServiceProtocol {
    func fetchNotifications() async -> Result<[NotificationModel], Error>
}

class NotificationsService {
    static let shared: NotificationsServiceProtocol = NotificationsService()
    private init() { }
}

extension NotificationsService: NotificationsServiceProtocol {
    func fetchNotifications() async -> Result<[NotificationModel], Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            return .success(PreviewModels.notifications)
        } catch {
            return .failure(error)
        }
    }
}
