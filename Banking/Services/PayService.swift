//
//  PayService.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
protocol PayServiceProtocol {
    func fetchCategories() async -> Result<[PayCategory], Error>
    func performPayment(accountNumber: String, amount: String) async -> Result<Void, Error>
}

class PayService {
    static let shared: PayServiceProtocol = PayService()
    private init() { }
}

extension PayService: PayServiceProtocol {
    func performPayment(accountNumber: String, amount: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
        }
    }
    
    func fetchCategories() async -> Result<[PayCategory], Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            return .success(PreviewModels.payCategories)
        } catch {
            return .failure(error)
        }
    }
}
