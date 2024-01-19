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
    
    func checkError(expectation: inout XCTestExpectation) {
        XCTAssertTrue(viewModel.showAlert)
        if viewModel.showAlert {
            XCTAssertEqual(viewModel.alertMessage, expectation.description)
            expectation.fulfill()
        }
    }
    
    func checkSuccess(expectation: inout XCTestExpectation) {
        XCTAssertFalse(viewModel.showAlert)
        if !self.viewModel.showAlert {
            XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
            expectation.fulfill()
        }
    }
    
    @MainActor func testGetFAQsWithError() async {
        service.fetchFAQError = true
        var expectation = expectation(description: "Error fetching FAQs")
        viewModel.getFAQs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            XCTAssertTrue(self.viewModel.faqs.isEmpty)
            self.checkError(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetFAQsWithSuccess() async {
        service.fetchFAQError = false
        var expectation = expectation(description: "No Error")
        viewModel.getFAQs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
}
