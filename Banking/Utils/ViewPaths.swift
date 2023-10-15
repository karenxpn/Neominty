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
    case pay
    case receive
    case more
    case notifications
    case allTransactions
    case attachCard
    case transferSuccess(amount: String, currency: CardCurrency, action: CustomAction)
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

enum ScanViewPaths: String, Identifiable {
    case attachCard
    
    var id: String {
        self.rawValue
    }
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
    case settings
    case changePin
    case faq
    case verifyAccount
    case accountRejected
    case accountVerified
}



