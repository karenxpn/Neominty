//
//  MockPayService.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import Foundation
import Alamofire
@testable import Banking

class MockPayService: PayServiceProtocol {
    var fetchCategoriesError = false
    var bindingToBindingError = false
    var bindingToCardError = false
    var performPaymentError = false
    
    func fetchCategories() async -> Result<[PayCategory], Error> {
        if fetchCategoriesError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching categories"]))
        } else {
            return .success(PreviewModels.payCategories)
        }
    }
    
    func performPaymentWithBindingId(sender: String, receiver: String, amount: Decimal, currency: String) async throws -> BindingToBindingPaymentResponseModel {
        if bindingToBindingError {
            throw NSError(domain: "Error",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Error performing binding to binding payment"])
        } else {
            return BindingToBindingPaymentResponseModel(message: "the transaction is completed")
        }
    }
    
    func performBindingToCardPayment(sender: String, receiver: String, amount: Decimal, currency: String) async throws -> BindingToCardPaymentResponseModel {
        if bindingToCardError {
            throw NSError(domain: "Error",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Error performing binding to card payment"])

        } else {
            return BindingToCardPaymentResponseModel(message: "the transaction is completed")
        }
    }
    
    func performPayment(amount: String) async -> Result<Void, Error> {
        if performPaymentError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error performing payment"]))

        } else {
            return .success(())
        }
    }
}
