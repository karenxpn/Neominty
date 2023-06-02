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

struct ExpensePointViewModel: Hashable {
    var model: ExpensePoint
    init(model: ExpensePoint) {
        self.model = model
    }
    
    var amount: Decimal     { self.model.amount }
    var interval: String    {
        get { self.model.interval }
        set { self.model.interval = newValue }
    }
    var timestamp: Date     {
        return self.model.timestamp.dateValue()
    }
}
