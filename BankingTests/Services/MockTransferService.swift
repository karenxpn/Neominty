//
//  MockTransferService.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import Foundation
import FirebaseFirestore
@testable import Banking

class MockTransferService: TransferServiceProtocol {
    let globalResponse = GlobalResponse(status: "success", message: "Success")
    var fetchRecentTransfersError = false
    var fetchRecentTransferHistoryError = false
    var fetchTransactionHistoryError = false
    var requestTransferError = false
    
    func fetchRecentTransfers() async -> Result<[RecentTransfer], Error> {
        if fetchRecentTransfersError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching recent transfers"]))

        } else {
            return .success(PreviewModels.recentTransferList)
        }
    }
    
    func fetchRecentTransferHistory(userID: String) async -> Result<[TransactionPreview], Error> {
        if fetchRecentTransferHistoryError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching recent transfers history"]))

        } else {
            return .success(PreviewModels.transactionListWithoutViewModel)
        }
    }
    
    func fetchTransactionHistory(userID: String, lastDoc: QueryDocumentSnapshot?) async -> Result<([TransactionPreview], QueryDocumentSnapshot?), Error> {
        if fetchTransactionHistoryError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching history"]))

        } else {
            return .success((PreviewModels.transactionListWithoutViewModel, nil))
        }
    }
    
    func requestTransfer(amount: String) async -> Result<GlobalResponse, Error> {
        if requestTransferError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error requesting transfer"]))

        } else {
            return .success(globalResponse)
        }
    }
}
