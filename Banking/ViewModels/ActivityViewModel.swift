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
    
    @Published var expense: Decimal = 0
    @Published var expensePoints: [ExpensePointViewModel] = []
    
    
    var manager: ActivityServiceProtocol
    var cardManager: CardServiceProtocol
    
    init(manager: ActivityServiceProtocol = ActivityService.shared,
         cardManager: CardServiceProtocol = CardService.shared) {
        self.manager = manager
        self.cardManager = cardManager
    }
    
    func setValues() {
        if selectedUnit == "week" {
            expense = activity!.weekTotal
            expensePoints = activity!.week
        } else if selectedUnit == "day" {
            expense = activity!.dayTotal
            expensePoints = activity!.day
        } else if selectedUnit == "month" {
            expense = activity!.monthTotal
            expensePoints = activity!.month
        } else if selectedUnit == "year" {
            expense = activity!.yearTotal
            expensePoints = activity!.year
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
        expense = 0
        expensePoints.removeAll(keepingCapacity: false)
        
        Task {
            let result = await manager.fetchActivity(bindingId: selectedCard)
            switch result {
            case .failure(_):
                break
            case .success(let activity):
                self.selectedUnit = ActivityUnit.week.rawValue
                self.activity = ActivityModelViewModel(model: activity)
                self.expense = self.activity!.weekTotal
                self.expensePoints = self.activity!.week
                print(self.activity)
            }
            if !Task.isCancelled {
                loadingActivity = false
            }
        }
    }
}
