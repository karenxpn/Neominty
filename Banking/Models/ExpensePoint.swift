//
//  ExpensePoint.swift
//  Banking
//
//  Created by Karen Mirakyan on 23.03.23.
//

import Foundation

struct ExpensePoint: Identifiable, Codable {
    let id: String = UUID().uuidString
    var unit: String
    var amount: Double
}
