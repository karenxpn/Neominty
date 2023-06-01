//
//  ActivityService.swift
//  Banking
//
//  Created by Karen Mirakyan on 24.03.23.
//

import Foundation
import FirebaseFirestore

protocol ActivityServiceProtocol {
    func fetchActivity(bindingId: String) async -> Result<ActivityModel, Error>
}

class ActivityService {
    static let shared: ActivityServiceProtocol = ActivityService()
    let db = Firestore.firestore()

    private init() { }
}

extension ActivityService: ActivityServiceProtocol {
    func fetchActivity(bindingId: String) async -> Result<ActivityModel, Error> {
        do {
            
            let docs = try await db.collection(Paths.transactions.rawValue)
                .whereField("bindingIds", arrayContains: bindingId)
                .order(by: "createdAt", descending: true)
                .limit(to: 10)
                .getDocuments()
                .documents
            
            var activity = try await db.collection(Paths.userTransferActivity.rawValue)
                .document(bindingId)
                .getDocument(as: ActivityModel.self)
            
            print("activity", activity)
                        
            let transactions = try docs.map({try $0.data(as: TransactionPreview.self)})
            activity.transactiions = transactions
            
            return .success(activity)
        } catch {
            return .failure(error)
        }

    }
}
