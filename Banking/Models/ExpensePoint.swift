//
//  ExpensePoint.swift
//  Banking
//
//  Created by Karen Mirakyan on 23.03.23.
//

import Foundation
import FirebaseFirestore

struct ExpensePoint: Codable, Hashable {
    var amount: Decimal
    var interval: String
    var timestamp: Timestamp
}
