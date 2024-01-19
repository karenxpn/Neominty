//
//  MockNotificationService.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import Foundation
import FirebaseFirestore
@testable import Banking

class MockNotificationService: NotificationsServiceProtocol {
    var fetchNotificationsError = false
    var markAllAsReadError = false
    var checkForUnreadNotificationError = false
    
    func fetchNotifications(userID: String, lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([NotificationModel], QueryDocumentSnapshot?), Error> {
        if fetchNotificationsError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching notifications"]))
        } else {
            return .success((PreviewModels.notifications, nil))
        }
    }
    
    func markAllAsRead(userID: String) async -> Result<Void, Error> {
        if markAllAsReadError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error when trying to mark all notifications as read"]))

        } else {
            return .success(())
        }
    }
    
    func checkForUnreadNotifications(userID: String, completion: @escaping (Bool) -> ()) {
        if checkForUnreadNotificationError {
            completion(false)
        } else {
            completion(true)
        }
    }
    
    
}
