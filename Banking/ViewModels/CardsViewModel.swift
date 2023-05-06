//
//  CardsViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import Foundation
import SwiftUI
import Combine

class CardsViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var cards = [CardModel]()
    
    @Published var cardNumber: String = ""
    @Published var cardHolder: String = ""
    @Published var cvv: String = ""
    @Published var expirationDate: String = ""
    
    @Published var cardType = CreditCardType.nonIdentified
    @Published var design: CardDesign = .blue
    
    
    var manager: CardServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var formURL = "https://www.google.com/"
    @Published var orderNumber: String = ""
    @Published var orderID: String = ""
    
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
    
    @MainActor func attachCard() {
        loading = true
        Task {
            let result = await manager.attachCards(cardNumber: cardNumber, cardHolder: cardHolder, expireDate: expirationDate, cvv: cvv)
            switch result {
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name("cardAttached"), object: nil)
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)

            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func deleteCard(id: String) {
        Task {
            let result = await manager.removeCard(id: id)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                self.cards.removeAll(where: { $0.id == id })
            }
        }
    }
    
    @MainActor func registerOrder() {
        
        loading = true
        Task {
            do {
                let result = try await manager.registerOrder()
                
                if result.error ?? false {
                    self.showAlert = result.error!
                    self.alertMessage = result.errorMessage!
                } else {
                    self.formURL = result.formUrl!
                    self.orderNumber = result.orderNumber
                    self.orderID = result.orderId!
                    print(result)
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.orderRegistered.rawValue), object: nil)
                }
                
            } catch let error as NetworkError {
                if let backendError = error.backendError {
                    self.alertMessage = backendError.message
                    self.showAlert.toggle()
                } else {
                    self.makeAlert(with: error.initialError, message: &self.alertMessage, alert: &self.showAlert)
                }
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    func getOrderStatus(orderId: String) {
        
        // do this on the server side and store card details, bank info, etc.
        manager.requestOrderStatus(orderNumber: 1, orderId: orderId)
            .sink { completion in
                print(completion)
                switch completion {
                case .failure(let error):
                    self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
                default:
                    break
                }
            } receiveValue: { response in
                if response.bindingInfo?.bindingId != nil {
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.cardAttached.rawValue), object: nil)
                } else if response.errorCode != "0" {
                    self.alertMessage = response.errorMessage ?? NSLocalizedString("somethingWentWrong", comment: "")
                    self.showAlert.toggle()
                } else {
                    self.alertMessage = response.actionCodeDescription
                    self.showAlert.toggle()
                }
                print(response)
            }.store(in: &cancellableSet)
    }
}
