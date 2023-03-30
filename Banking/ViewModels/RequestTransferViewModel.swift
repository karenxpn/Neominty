//
//  RequestTransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import Foundation
class RequestTransferViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var cards = [CardModel]()
    
    var cardManager: CardServiceProtocol
    init(cardManager: CardServiceProtocol = CardService.shared) {
        self.cardManager = cardManager
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
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
