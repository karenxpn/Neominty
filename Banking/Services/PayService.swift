//
//  PayService.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

protocol PayServiceProtocol {
    func fetchCategories() async -> Result<[PayCategory], Error>
    func performPaymentWithBindingId(sender: String, receiver: String, amount: Decimal) async throws -> BothBindingPaymentResponse
    func performPayment(amount: String) async -> Result<Void, Error>
}

class PayService {
    static let shared: PayServiceProtocol = PayService()
    let db = Firestore.firestore()

    private init() { }
}

extension PayService: PayServiceProtocol {
    func performPaymentWithBindingId(sender: String, receiver: String, amount: Decimal) async throws -> BothBindingPaymentResponse {
        let url = URL(string: "\(Credentials.functions_base_url)bothBindingPayment")!
        
        let params: Parameters = [
            "sender": sender,
            "receiver": receiver,
            "amount": amount
        ]
        
        do {
            let token = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true).token
            let headers: HTTPHeaders? = ["Authorization": "Bearer \(token ?? "")"]
            
            return try await withUnsafeThrowingContinuation({ continuation in
                AF.request(url,
                           method: .post,
                           parameters: params,
                           encoding: URLEncoding.queryString,
                           headers: headers)
                .validate()
                .responseDecodable(of: BothBindingPaymentResponse.self) { response in

                    if response.error != nil {
                        response.error.map { err in
                            let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                            continuation.resume(throwing: NetworkError(initialError: err, backendError: backendError))
                        }
                    }
                    
                    if let registered = response.value {
                        continuation.resume(returning: registered)
                    }
                }
            })
            
        } catch {
            throw error
        }
    }
    
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
