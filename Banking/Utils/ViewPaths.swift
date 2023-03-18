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
    case home
    case send
    case exchange
    case receive
    case more
    case allTransactions
    
    var id: String {
        self.rawValue
    }
}

enum MyCardViewPaths: String, Identifiable {
    case myCard
    
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
    case analytics
    
    var id: String {
        self.rawValue
    }
}

enum ProfileViewPaths: String, Identifiable {
    case profile
    
    var id: String {
        self.rawValue
    }
}



