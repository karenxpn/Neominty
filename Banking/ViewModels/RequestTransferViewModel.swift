//
//  RequestTransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import Foundation
class RequestTransferViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var loadingRequest: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var cards = [CardModel]()
    
    @Published var amount: String = ""
    
    @Published var selectedCard: CardModel?
    @Published var requestType: RequestType = .link
    
    // phone request
    @Published var country: String = "AM"
    @Published var code: String = "374"
    @Published var phoneNumber: String = ""
    @Published var flag: String = "🇦🇲"
    
    // email request
    @Published var email: String = ""
    @Published var isEmailValid: Bool = false
    
    @Published var generatedLink: String = ""
    
    var cardManager: CardServiceProtocol
    var manager: TransferServiceProtocol
    init(cardManager: CardServiceProtocol = CardService.shared,
         manager: TransferServiceProtocol = TransferService.shared) {
        self.cardManager = cardManager
        self.manager = manager
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
    
    @MainActor func requestPayment() {
        loadingRequest = true
        Task {
            let result = await manager.requestTransfer(type: requestType,
                                                       amount: amount,
                                                       currency: selectedCard?.currency.rawValue ?? "USD",
                                                       phone: "+\(code)\(phoneNumber)",
                                                       email: email)
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let response):
                self.generatedLink = response.message
                NotificationCenter.default.post(name: Notification.Name("requestPaymentSent"), object: nil)
                print(response)
            }
            
            if !Task.isCancelled {
                loadingRequest = false
            }
        }
    }
}
