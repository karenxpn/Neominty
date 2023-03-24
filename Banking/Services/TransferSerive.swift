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
    func fetchTransferHistory(page: Int) async -> Result<[TransactionPreview], Error>
}

class TransferService {
    static let shared: TransferServiceProtocol = TransferService()
    private init() { }
}

extension TransferService: TransferServiceProtocol {
    func fetchTransferHistory(page: Int) async -> Result<[TransactionPreview], Error> {
        if page == 0 {
            return .success([PreviewModels.transactionListWithoutViewModel.first!])
        } else if page == 1 {
            return .success([PreviewModels.transactionListWithoutViewModel.last!])
        } else {
            return .success([])
        }
    }
    
    func fetchRecentTransfers() async -> Result<[RecentTransfer], Error> {
        return .success(PreviewModels.recentTransferList)
    }
}
