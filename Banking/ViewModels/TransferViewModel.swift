//
//  TransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
import SwiftUI

class TransferViewModel: AlertViewModel, ObservableObject {
    @Published var selectedTransfer: RecentTransfer?
    @Published var transferAmount: String = ""
    @Published var newTransferImage: Data?
    
    @Published var transactionUsers = [RecentTransfer]()
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var randomColor: Color
    
    
    var manager: TransferServiceProtocol
    
    init(manager: TransferServiceProtocol = TransferService.shared) {
        self.manager = manager
        self.randomColor = Color(hex: [
            "#1DAB87", "#1D3A70", "#6B7280", "#1D2734",
            "#59E3A7", "#FB923C", "#000000", "#004D40"
        ].randomElement() ?? "#000000")!
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
    
    @MainActor func startTransaction(card: CardModel, recentTransfer: RecentTransfer?, cardNumber: String?) {
        loading = true
        
        Task {
            
            do {
                let result = try await manager.bindingToCardTransaction(sender: card.bindingId,
                                                                        receiver: recentTransfer?.card ?? cardNumber!,
                                                                        amount: self.transferAmount,
                                                                        currency: card.currency.rawValue)
                NotificationCenter.default.post(name: Notification.Name(NotificationName.transferSuccess.rawValue), object: nil)
                
                print("result = \(result)")
            } catch {
                print(error)
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
