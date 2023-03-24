//
//  ActivityViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import Foundation
class ActivityViewModel: AlertViewModel, ObservableObject {
    
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
    init(manager: ActivityServiceProtocol = ActivityService.shared) {
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
                if !cards.isEmpty {
                    self.selectedCard = cards[0].number
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
        Task {
            let result = await manager.fetchActivity(cardNumber: selectedCard, unit: selectedUnit)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let activity):
                self.activity = ActivityModelViewModel(model: activity)
            }
            if !Task.isCancelled {
                loadingActivity = false
            }
        }
    }
}
