//
//  PayService.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
protocol PayServiceProtocol {
    func fetchCategories() async -> Result<[PayCategory], Error>
}

class PayService {
    static let shared: PayServiceProtocol = PayService()
    private init() { }
}

extension PayService: PayServiceProtocol {
    func fetchCategories() async -> Result<[PayCategory], Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            return .success(PreviewModels.payCategories)
        } catch {
            return .failure(error)
        }
    }
}
