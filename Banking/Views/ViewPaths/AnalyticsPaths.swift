//
//  AnalyticsPaths.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.25.
//

import Foundation

enum AnalyticsViewPaths: String, Identifiable {
    case allTransactions
    case attachCard
    
    var id: String {
        self.rawValue
    }
}
