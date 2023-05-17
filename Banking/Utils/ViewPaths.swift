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

enum HomeViewPaths: String, Identifiable {
    // transfer
    case send
    
    case pay
    case receive
    case more
    case notifications
    case allTransactions
    case attachCard
    
    var id: String {
        self.rawValue
    }
}

enum MyCardViewPaths: String, Identifiable {
    case attachCard
    
    var id: String {
        self.rawValue
    }
}

enum ScanViewPaths: String, Identifiable {
    case scan
    
    var id: String {
        self.rawValue
    }
}

enum AnalyticsViewPaths: String, Identifiable {
    case allTransactions
    
    var id: String {
        self.rawValue
    }
}

enum AccountViewPaths: String, Identifiable {
    
    case info
    case settings
    case changePin
    case faq
    
    var id: String {
        self.rawValue
    }
}



