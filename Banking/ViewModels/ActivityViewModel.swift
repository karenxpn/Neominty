//
//  ActivityViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import Foundation
import SwiftUI

class ActivityViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var loading: Bool = false
    @Published var loadingActivity: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var cards = [CardModel]()
    @Published var activity: ActivityModelViewModel?
    
    @Published var activityUnit = [ActivityUnit.day.rawValue,
                                   ActivityUnit.week.rawValue,
                                   ActivityUnit.month.rawValue,
                                   ActivityUnit.year.rawValue]
    
    @Published var selectedUnit = ActivityUnit.week.rawValue
    @Published var selectedCard: String = ""
    
    
    var manager: ActivityServiceProtocol
    var cardManager: CardServiceProtocol
    
    init(manager: ActivityServiceProtocol = ActivityService.shared,
         cardManager: CardServiceProtocol = CardService.shared) {
        self.manager = manager
        self.cardManager = cardManager
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
                if !cards.isEmpty {
                    self.selectedCard = cards[0].bindingId
                    self.getActivity()
                }
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func getActivity() {
        loadingActivity = true
        activity = nil
        
        Task {
            let result = await manager.fetchActivity(bindingId: selectedCard)
            switch result {
            case .failure(_):
                break
            case .success(let activity):
                self.activity = ActivityModelViewModel(model: activity)
            }
            if !Task.isCancelled {
                loadingActivity = false
            }
        }
    }
}
