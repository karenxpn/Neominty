//
//  PayService.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
import FirebaseFirestore

protocol PayServiceProtocol {
    func fetchCategories() async -> Result<[PayCategory], Error>
    func performPayment(amount: String) async -> Result<Void, Error>
}

class PayService {
    static let shared: PayServiceProtocol = PayService()
    let db = Firestore.firestore()

    private init() { }
}

extension PayService: PayServiceProtocol {
    func performPayment(amount: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        }
    }
    
    func fetchCategories() async -> Result<[PayCategory], Error> {
        do {
            let docs = try await db.collection(Paths.payments.rawValue)
                .getDocuments()
                .documents
            
            let payments = try docs.map { try $0.data(as: PayCategory.self ) }
            return .success(payments)
        } catch {
            return .failure(error)
        }
    }
}
