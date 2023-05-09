//
//  TransferSerive.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
import Combine
import FirebaseFirestore

protocol TransferServiceProtocol {
    func fetchRecentTransfers() async -> Result<[RecentTransfer], Error>
    func fetchRecentTransferHistory(userID: String) async -> Result<[TransactionPreview], Error>
    func fetchTransactionHistory(userID: String, lastDoc: QueryDocumentSnapshot?) async -> Result<([TransactionPreview], QueryDocumentSnapshot?), Error>
    func requestTransfer(type: RequestType, amount: String, currency: String, phone: String, email: String) async -> Result<GlobalResponse, Error>
}

class TransferService {
    static let shared: TransferServiceProtocol = TransferService()
    let db = Firestore.firestore()

    private init() { }
}

extension TransferService: TransferServiceProtocol {
    func fetchRecentTransferHistory(userID: String) async -> Result<[TransactionPreview], Error> {
        do {
            let docs = try await db
                .collection(Paths.transactions.rawValue)
                .whereField("users", arrayContains: userID)
                .order(by: "createdAt", descending: true)
                .limit(to: 10)
                .getDocuments()
                .documents
            
            let transactions = try docs.map({try $0.data(as: TransactionPreview.self)})
            return .success(transactions)
            
        } catch {
            return .failure(error)
        }
    }
    
    func requestTransfer(type: RequestType, amount: String, currency: String, phone: String, email: String) async -> Result<GlobalResponse, Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            var message = ""
            if type == .link {
                message = "www.neominty.com/request8720money/cardnumber/id8645153"
            } else {
                message = "Request is sent"
            }
            return .success(GlobalResponse(status: "success", message: message))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchTransactionHistory(userID: String, lastDoc: QueryDocumentSnapshot?) async -> Result<([TransactionPreview], QueryDocumentSnapshot?), Error> {
        do {
            var query: Query = db.collection(Paths.transactions.rawValue)
                .whereField("users", arrayContains: userID)
                .order(by: "createdAt", descending: true)
            
            if lastDoc == nil   { query = query.limit(to: 2) }
            else                { query = query.start(afterDocument: lastDoc!).limit(to: 2) }
            
            let docs = try await query.getDocuments().documents
            let transactions = try docs.map { try $0.data(as: TransactionPreview.self ) }
            
            return .success((transactions, docs.last))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchRecentTransfers() async -> Result<[RecentTransfer], Error> {
        return .success(PreviewModels.recentTransferList)
    }
}
