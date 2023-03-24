//
//  AllTransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 24.03.23.
//

import Foundation
class AllTransferViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var transfers = [TransactionPreviewViewModel]()
    @Published var page: Int = 0
    
    var manager: TransferServiceProtocol
    init(manager: TransferServiceProtocol = TransferService.shared) {
        self.manager = manager
    }
    
    @MainActor func getTransactionList() {
        loading = true
        Task {
            
            let result = await manager.fetchTransferHistory(page: page)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let transfers):
                self.transfers.append(contentsOf: transfers.map(TransactionPreviewViewModel.init))
                self.page += 1
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
