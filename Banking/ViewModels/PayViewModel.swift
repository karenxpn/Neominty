//
//  PayViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
class PayViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var loadingPayment: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    @Published var search: String = ""
    @Published var categories = [PayCategoryViewModel]()
    @Published var accountNumber: String = ""
    
    @Published var cards = [CardModel]()
    @Published var selectedCard: CardModel?
    @Published var amount: String = ""
    @Published var selectedPaymentCategory: SubCategory?

    
    var manager: PayServiceProtocol
    var cardManager: CardServiceProtocol
    
    init(manager: PayServiceProtocol = PayService.shared,
         cardManager: CardServiceProtocol = CardService.shared) {
        self.manager = manager
        self.cardManager = cardManager
    }
    
    @MainActor func getCategories() {
        loading = true
        Task {
            let result = await manager.fetchCategories()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let categories):
                self.categories = categories.map(PayCategoryViewModel.init)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
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
    
    @MainActor func performPayment() {
        loadingPayment = true
        Task {
            let result = await manager.performPayment(accountNumber: accountNumber, amount: amount)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name(NotificationName.paymentCompleted.rawValue), object: nil)
            }
            
            if !Task.isCancelled {
                loadingPayment = false
            }
        }
    }
}
