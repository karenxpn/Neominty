//
//  ViewPaths.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import Foundation
import SwiftUI

enum ViewPaths: String, Identifiable {
        
    case setPasscode
    case confirmPasscode
    case enableBiometric
    case verifyPhoneNumber
    
    var id: String {
        self.rawValue
    }
}

enum HomeViewPaths: Equatable, Hashable {    
    case send(cards: [CardModel])
    case transferDetails(card: CardModel, recentTransfer: RecentTransfer?, receiverCardNumber: String)
    case pay
    case selectPaySubcategory(category: PayCategoryViewModel, vm: PayViewModel)
    case paymentDetails(vm: PayViewModel)
    case receive
    case more
    case notifications
    case allTransactions
    case attachCard
    case transferSuccess(amount: String, currency: CardCurrency, action: CustomAction)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .send(let cards):
            hasher.combine(0)
            hasher.combine(cards)
        case .transferDetails(let card, let recentTransfer, let receiverCardNumber):
            hasher.combine(1)
            hasher.combine(card)
            hasher.combine(recentTransfer)
            hasher.combine(receiverCardNumber)
        case .pay:
            hasher.combine(2)
        case .selectPaySubcategory(let category, let vm):
            hasher.combine(3)
            hasher.combine(category)
            hasher.combine(ObjectIdentifier(vm))
        case .paymentDetails(let vm):
            hasher.combine(4)
            hasher.combine(ObjectIdentifier(vm))
        case .receive:
            hasher.combine(5)
        case .more:
            hasher.combine(6)
        case .notifications:
            hasher.combine(7)
        case .allTransactions:
            hasher.combine(8)
        case .attachCard:
            hasher.combine(9)
        case .transferSuccess(let amount, let currency, let action):
            hasher.combine(10)
            hasher.combine(amount)
            hasher.combine(currency)
            hasher.combine(action)
        }
    }
    
    static func == (lhs: HomeViewPaths, rhs: HomeViewPaths) -> Bool {
        switch (lhs, rhs) {
        case (.send(let cards1), .send(let cards2)):
            return cards1 == cards2
        case (.transferDetails(let card1, let recentTransfer1, let receiver1), .transferDetails(let card2, let recentTransfer2, let receiver2)):
            return card1 == card2 && recentTransfer1 == recentTransfer2 && receiver1 == receiver2
        case (.pay, .pay),
             (.receive, .receive),
             (.more, .more),
             (.notifications, .notifications),
             (.allTransactions, .allTransactions),
             (.attachCard, .attachCard):
            return true
        case (.selectPaySubcategory(let category1, let vm1), .selectPaySubcategory(let category2, let vm2)):
            return category1 == category2 && ObjectIdentifier(vm1) == ObjectIdentifier(vm2)
        case (.paymentDetails(let vm1), .paymentDetails(let vm2)):
            return ObjectIdentifier(vm1) == ObjectIdentifier(vm2)
        case (.transferSuccess(let amount1, let currency1, let action1), .transferSuccess(let amount2, let currency2, let action2)):
            return amount1 == amount2 && currency1 == currency2 && action1 == action2
        default:
            return false
        }
    }
}

struct CustomAction {
    let action: () -> Void
}

extension CustomAction: Equatable {
    static func == (lhs: CustomAction, rhs: CustomAction) -> Bool {
        // Compare your custom actions here based on your specific criteria
        // For simplicity, we'll consider them equal if their actions are equal
        return ObjectIdentifier(lhs.action as AnyObject) == ObjectIdentifier(rhs.action as AnyObject)
    }
}

extension CustomAction: Hashable {
    func hash(into hasher: inout Hasher) {
        // Create a unique hash value based on the action
        ObjectIdentifier(action as AnyObject).hash(into: &hasher)
    }
}


enum MyCardViewPaths: String, Identifiable {
    case attachCard
    
    var id: String {
        self.rawValue
    }
}

enum ScanViewPaths: Equatable, Hashable {
    case attachCard
    case transferSuccess(amount: String, currency: CardCurrency, action: CustomAction)
}

enum AnalyticsViewPaths: String, Identifiable {
    case allTransactions
    case attachCard
    
    var id: String {
        self.rawValue
    }
}

enum AccountViewPaths: Equatable, Hashable {
    
    case info(name: String?, flag: String?, phone: String?, email: String?)
    case accountEmail(email: String?)
    case settings
    case changePin
    case faq
    case allFaq
    case verifyAccount
    case accountRejected
    case accountVerified
}