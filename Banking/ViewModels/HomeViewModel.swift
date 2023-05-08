//
//  HomeViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation
import SwiftUI


class HomeViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    @Published var cards = [CardModel]()
    @Published var transactions = PreviewModels.transactionList
    @Published var hasUnreadNotification: Bool = false
    
    var cardManager: CardServiceProtocol
    var notificationManager: NotificationsServiceProtocol
    init(cardManager: CardServiceProtocol = CardService.shared,
         notificationManager: NotificationsServiceProtocol = NotificationsService.shared) {
        self.cardManager = cardManager
        self.notificationManager = notificationManager
        
        super.init()
        
        checkUnreadNotificationExistense()
    }
    
    func checkUnreadNotificationExistense() {
        notificationManager.checkForUnreadNotifications(userID: userID, completion: { response in
            self.hasUnreadNotification = response
        })
    }
    
    
    @MainActor func getCards() {
        loading = true
        Task {
            let result = await cardManager.fetchCards(userID: userID)
            print(result)
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
