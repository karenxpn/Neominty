//
//  TransferSerive.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
import Combine

protocol TransferServiceProtocol {
    func fetchRecentTransfers() async -> Result<[RecentTransfer], Error>
}

class TransferService {
    static let shared: TransferServiceProtocol = TransferService()
    private init() { }
}

extension TransferService: TransferServiceProtocol {
    func fetchRecentTransfers() async -> Result<[RecentTransfer], Error> {
        return .success(PreviewModels.recentTransferList)
    }
}
