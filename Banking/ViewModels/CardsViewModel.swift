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
    @AppStorage("orderNumber") private var orderNumber: Int = 1
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
    
    func getOrderNumberAndRegister() {
        orderNumber += 1
        registerOrder(orderNumber: orderNumber)
    }
        
    func registerOrder(orderNumber: Int) {
        manager.registerOrder(orderNumber: orderNumber).sink { completion in
            switch completion {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            default:
                break
            }
        } receiveValue: { response in
            if response.error ?? false {
                self.showAlert = response.error!
                self.alertMessage = response.errorMessage!
            } else {
                // open form url
                self.formURL = response.formUrl!
                NotificationCenter.default.post(name: Notification.Name(NotificationName.orderRegistered.rawValue), object: nil)
            }
            print(response)
        }.store(in: &cancellableSet)
    }
    
    func getOrderStatus(orderId: String) {
        manager.requestOrderStatus(orderNumber: orderNumber, orderId: orderId)
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
