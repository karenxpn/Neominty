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
    func requestTransfer(type: RequestType, amount: String, currency: String, phone: String, email: String) async -> Result<GlobalResponse, Error>
}

class TransferService {
    static let shared: TransferServiceProtocol = TransferService()
    private init() { }
}

extension TransferService: TransferServiceProtocol {
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
