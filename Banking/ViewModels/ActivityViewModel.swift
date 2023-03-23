//
//  ActivityViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import Foundation
class ActivityViewModel: AlertViewModel, ObservableObject {
    @Published var activity = ActivityModelViewModel(model:
                                                        ActivityModel(income: "$5,300.00", expenses: "$2,265.80",
                                                                      expensesPoints: PreviewModels.expensesPoints, transactiions: PreviewModels.transactionListWithoutViewModel))
    
    
    @Published var activityUnit = [ActivityUnit.day.rawValue,
                                   ActivityUnit.week.rawValue,
                                   ActivityUnit.month.rawValue,
                                   ActivityUnit.year.rawValue]
    @Published var selectedUnit = ActivityUnit.week.rawValue
}
