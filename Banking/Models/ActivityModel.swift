//
//  ActivityModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 23.03.23.
//

import Foundation
struct ActivityModel: Codable {
    var totalday: Decimal
    var totalweek: Decimal
    var totalmonth: Decimal
    var totalyear: Decimal
    var day: [ExpensePoint]
    var week: [ExpensePoint]
    var month: [ExpensePoint]
    var year: [ExpensePoint]
    var transactiions: [TransactionPreview]?
}


struct ActivityModelViewModel {
    var model: ActivityModel
    init(model: ActivityModel) {
        self.model = model
    }
    
    var dayTotal: Decimal                                { self.model.totalday }
    var weekTotal: Decimal                               { self.model.totalweek }
    var monthTotal: Decimal                              { self.model.totalmonth }
    var yearTotal: Decimal                               { self.model.totalyear }
    
    var day: [ExpensePoint]          { self.model.day }
    var week: [ExpensePoint]         { self.model.week }
    var month: [ExpensePoint]        { self.model.month }
    var year: [ExpensePoint]         { self.model.year }

    var transactions: [TransactionPreviewViewModel] {
        if self.model.transactiions != nil {
            return self.model.transactiions!.map(TransactionPreviewViewModel.init)
        } else {
            return []
        }
    }
}
