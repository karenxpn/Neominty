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
    
    @Published var loading: Bool = true
    @Published var loadingTransactions: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    @Published var cards = [CardModel]()
    @Published var transactions = [TransactionPreviewViewModel]()
    @Published var hasUnreadNotification: Bool = false
    
    var transferManager: TransferServiceProtocol
    var cardManager: CardServiceProtocol
    var notificationManager: NotificationsServiceProtocol
    init(transferManager: TransferServiceProtocol = TransferService.shared,
        cardManager: CardServiceProtocol = CardService.shared,
         notificationManager: NotificationsServiceProtocol = NotificationsService.shared) {
        self.transferManager = transferManager
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
    
    @MainActor func getRecentTransfers() {
        loadingTransactions = true
        alertMessage = ""
        Task {
            let result = await transferManager.fetchRecentTransferHistory(userID: userID)
            print(result)
            switch result {
            case .success(let recent):
                self.transactions = recent.map(TransactionPreviewViewModel.init)
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loadingTransactions = false
            }
        }
    }
    
    @MainActor func getCards() {
        loading = true
        alertMessage = ""
        Task {
            let result = await cardManager.fetchCards(userID: userID)
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
