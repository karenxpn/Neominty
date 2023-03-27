//
//  CardsViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import Foundation
class CardsViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var cards = [CardModel]()
    
    
    var manager: CardServiceProtocol
    init(manager: CardServiceProtocol = CardService.shared) {
        self.manager = manager
    }
    @MainActor func getCards() {
        loading = true
        Task {
            let result = await manager.fetchCards()
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
