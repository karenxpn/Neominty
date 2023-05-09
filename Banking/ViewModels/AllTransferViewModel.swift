//
//  AllTransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 24.03.23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class AllTransferViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var transfers = [TransactionPreviewViewModel]()
    @Published var lastTransfer: QueryDocumentSnapshot?
    
    var manager: TransferServiceProtocol
    init(manager: TransferServiceProtocol = TransferService.shared) {
        self.manager = manager
    }
    
    @MainActor func getTransactionList() {
        loading = true
        Task {
            
            let result = await manager.fetchTransactionHistory(userID: userID, lastDoc: lastTransfer)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let transfers):
                self.transfers.append(contentsOf: transfers.0.map(TransactionPreviewViewModel.init))
                self.lastTransfer = transfers.1
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
