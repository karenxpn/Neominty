//
//  TransactionPreview.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation
struct TransactionPreview: Identifiable, Codable {
    var id: String
    var icon: String
    var name: String
    var type: String
    var amount: Float
}

struct TransactionPreviewViewModel: Identifiable {
    var model: TransactionPreview
    init(model: TransactionPreview) {
        self.model = model
    }
    
    var id: String      { self.model.id }
    var icon: String    { self.model.icon }
    var name: String    { self.model.name }
    var type: String    { self.model.type }
    
    var amount: String {
        if self.model.amount < 0 {
            return "- $\(abs(self.model.amount))"
        }
        
        return "+ $\(self.model.amount)"
    }
}
