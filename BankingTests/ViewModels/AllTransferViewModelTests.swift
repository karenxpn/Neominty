//
//  AllTransferViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import XCTest
@testable import Banking

final class AllTransferViewModelTests: XCTestCase {

    var service: MockTransferService!
    var viewModel: AllTransferViewModel!
    
    override func setUp() {
        self.service = MockTransferService()
        self.viewModel = AllTransferViewModel(manager: self.service)
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
    
    @MainActor func testGetAllTransfersWithError() async {
        service.fetchTransactionHistoryError = true
        var expectation = expectation(description: "Error fetching history")
        viewModel.getTransactionList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetAllTransfersWithSuccess() async {
        service.fetchTransactionHistoryError = false
        var expectation = expectation(description: "No error")
        viewModel.getTransactionList()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
}
