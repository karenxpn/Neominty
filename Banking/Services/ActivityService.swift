//
//  ActivityService.swift
//  Banking
//
//  Created by Karen Mirakyan on 24.03.23.
//

import Foundation
protocol ActivityServiceProtocol {
    func fetchActivity(cardNumber: String, unit: String) async -> Result<ActivityModel, Error>
}

class ActivityService {
    static let shared: ActivityServiceProtocol = ActivityService()
    private init() { }
}

extension ActivityService: ActivityServiceProtocol {
    func fetchActivity(cardNumber: String, unit: String) async -> Result<ActivityModel, Error> {
        do {
            
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            return .success(ActivityModel(income: "$ 5300",
                                          expenses: "$ 2265.80",
                                          expensesPoints: PreviewModels.expensesPoints,
                                          transactiions: PreviewModels.transactionListWithoutViewModel))
        } catch {
            return .failure(error)
        }

    }
}
