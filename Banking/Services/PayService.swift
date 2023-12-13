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
    func performPaymentWithBindingId(sender: String, receiver: String, amount: Decimal, currency: String) async throws -> BindingToBindingPaymentResponseModel
    func performBindingToCardPayment(sender: String, receiver: String, amount: Decimal, currency: String) async throws -> BindingToCardPaymentResponseModel
    func performPayment(amount: String) async -> Result<Void, Error>
}

class PayService {
    static let shared: PayServiceProtocol = PayService()
    let db = Firestore.firestore()

    private init() { }
}

extension PayService: PayServiceProtocol {
    func performBindingToCardPayment(sender: String, receiver: String, amount: Decimal, currency: String) async throws -> BindingToCardPaymentResponseModel {
        let url = URL(string: "\(Credentials.functions_base_url)bindingToCardPayment")!
        let params = BindingToCardPaymentRequestModel(sender: sender,
                                                      receiver: receiver,
                                                      amount: amount,
                                                      currency: currency)
        
        return try await APIHelper.shared.httpRequest(params: params, url: url, responseType: BindingToCardPaymentResponseModel.self)
    }
    
    func performPaymentWithBindingId(sender: String, receiver: String, amount: Decimal, currency: String) async throws -> BindingToBindingPaymentResponseModel {
        let url = URL(string: "\(Credentials.functions_base_url)bindingToBindingPayment")!
        
        let params = BindingToBindingPaymentRequestModel(sender: sender,
                                                         receiver: receiver,
                                                         amount: amount,
                                                         currency: currency)
        
        return try await APIHelper.shared.httpRequest(params: params, url: url, responseType: BindingToBindingPaymentResponseModel.self)
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
