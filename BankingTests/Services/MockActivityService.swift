//
//  MockActivityService.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import Foundation
@testable import Banking

class MockActivityService: ActivityServiceProtocol {
    var fetchActivityError: Bool = false
    
    func fetchActivity(bindingId: String) async -> Result<ActivityModel, Error> {
        if fetchActivityError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching activity"]))

        } else {
            return .success(ActivityModel(day: PreviewModels.expensesPoints,
                                          week: PreviewModels.expensesPoints,
                                          month: PreviewModels.expensesPoints,
                                          year: PreviewModels.expensesPoints))
        }
    }
}
