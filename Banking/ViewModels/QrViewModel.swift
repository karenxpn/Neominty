//
//  QrViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.04.23.
//

import Foundation
import SwiftUI

class QrViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

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
        self.alertMessage = ""
        
        Task {
            let result = await cardManager.fetchCards(userID: userID)
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
    
    @MainActor func performPayment(receiver: String, amount: String, action: @escaping () -> ()) {
        
        loading = true
        Task {
            do {
                let _ = try await payManager.performPaymentWithBindingId(sender: selectedCard!.bindingId,
                                                                 receiver: receiver,
                                                                 amount: Decimal(string: amount) ?? 0,
                                                                 currency: selectedCard!.currency.rawValue)
                action()
                
            } catch let error as NetworkError {
                self.makeNetworkAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
