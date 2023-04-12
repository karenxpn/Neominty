//
//  QrViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.04.23.
//

import Foundation
import SwiftUI

class QrViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var selectedCard: CardModel?
    @Published var cards = [CardModel]()
    
    var cardManager: CardServiceProtocol
    var payManager: PayServiceProtocol
    init(cardManager: CardServiceProtocol = CardService.shared,
         payManager: PayServiceProtocol = PayService.shared) {
        self.cardManager = cardManager
        self.payManager = payManager
    }
    
    @MainActor func getCards() {
        loading = true
        Task {
            let result = await cardManager.fetchCards()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let cards):
                self.cards = cards
                self.selectedCard = cards.first(where: { $0.defaultCard })
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func performPayment(account: String, amount: String) {
        loading = true
        Task {
            let result = await payManager.performPayment(accountNumber: account, amount: amount)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name(NotificationName.paymentCompleted.rawValue), object: nil)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
