//
//  ActivityViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import Foundation
class ActivityViewModel: AlertViewModel, ObservableObject {
    @Published var plot: [ExpensePoint] = [
        .init(day: "Mon", amount: 989),
        .init(day: "Tue", amount: 1200),
        .init(day: "Wed", amount: 750),
        .init(day: "Thu", amount: 650),
        .init(day: "Fri", amount: 950),
        .init(day: "Sat", amount: 650),
        .init(day: "Sun", amount: 1200)]
}
