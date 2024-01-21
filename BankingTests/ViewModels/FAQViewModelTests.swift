//
//  FAQViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import XCTest
@testable import Banking

final class FAQViewModelTests: XCTestCase {

    var service: MockAccountService!
    var viewModel: FAQViewModel!
    
    override func setUp() {
        self.service = MockAccountService()
        self.viewModel = FAQViewModel(manager: self.service)
    }
    
    func testGetFAQsWithError() async {
        service.fetchFAQError = true
        await wait(for: { await self.viewModel.getFAQs() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching FAQs")
        XCTAssertTrue(self.viewModel.faqs.isEmpty)
    }
    
    func testGetFAQsWithSuccess() async {
        service.fetchFAQError = false
        await wait(for: { await self.viewModel.getFAQs() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
}
