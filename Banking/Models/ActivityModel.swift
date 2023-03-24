//
//  ActivityModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 23.03.23.
//

import Foundation
struct ActivityModel: Codable {
    var income: String
    var expenses: String
    var expensesPoints: [ExpensePoint]
    var transactiions: [TransactionPreview]
}


struct ActivityModelViewModel {
    var model: ActivityModel
    init(model: ActivityModel) {
        self.model = model
    }
    
    var income: String                              { self.model.income }
    var expenses: String                            { self.model.expenses }
    var expensesPoints: [ExpensePoint]              { self.model.expensesPoints}
    var transactions: [TransactionPreviewViewModel] { self.model.transactiions.map(TransactionPreviewViewModel.init)}
}
