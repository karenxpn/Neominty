//
//  ViewPaths.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.25.
//

import Foundation

enum ViewPaths: String, Identifiable {
        
    case setPasscode
    case confirmPasscode
    case enableBiometric
    case verifyPhoneNumber
    
    var id: String {
        self.rawValue
    }
}

