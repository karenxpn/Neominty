//
//  TransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
class TransferViewModel: AlertViewModel, ObservableObject {
    @Published var isCardValid: Bool = false
    @Published var selectedTransfer: RecentTransfer?
    @Published var transferAmount: String = ""
    @Published var newTransferImage: Data?

    @Published var cardNumber: String = ""
    @Published var transactionUsers = [RecentTransfer]()
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var manager: TransferServiceProtocol
    
    init(manager: TransferServiceProtocol = TransferService.shared) {
        self.manager = manager
    }
    
    @MainActor func getRecentTransfers() {
        loading = true
        
        Task {
            let result = await manager.fetchRecentTransfers()
            switch result {
            case .failure(let error):
                return self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let transfers):
                self.transactionUsers = transfers
            }
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func startTransaction(card: CardModel) {
        loading = true
        
        Task {
            
            do {
                let result = try await manager.bindingToCardTransaction(sender: card.bindingId,
                                                                    card: self.selectedTransfer?.card ?? "",
                                                                    amount: self.transferAmount,
                                                                    currency: card.currency.rawValue)
                NotificationCenter.default.post(name: Notification.Name(NotificationName.transferSuccess.rawValue), object: nil)
                
                print("result = \(result)")
            } catch {
                print(error)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
