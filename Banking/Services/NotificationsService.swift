//
//  NotificationsService.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.23.
//

import Foundation
import FirebaseFirestore

protocol NotificationsServiceProtocol {
    func fetchNotifications(userID: String, lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([NotificationModel], QueryDocumentSnapshot?), Error>
}

class NotificationsService {
    static let shared: NotificationsServiceProtocol = NotificationsService()
    let db = Firestore.firestore()

    private init() { }
}

extension NotificationsService: NotificationsServiceProtocol {
    func fetchNotifications(userID: String, lastDocSnapshot: QueryDocumentSnapshot?) async -> Result<([NotificationModel], QueryDocumentSnapshot?), Error> {
        do {
            var query: Query = db.collection(Paths.users.rawValue)
                .document(userID)
                .collection("notifications")
                .order(by: "created_at", descending: true)
            
            if lastDocSnapshot == nil   { query = query.limit(to: 2) }
            else                        { query = query.start(afterDocument: lastDocSnapshot!).limit(to: 2) }
            
            let docs = try await query.getDocuments().documents
            let notifications = try docs.map { try $0.data(as: NotificationModel.self ) }

            return .success((notifications, docs.last))
        } catch {
            return .failure(error)
        }
    }
}
