//
//  ActivityViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import XCTest
@testable import Banking

final class ActivityViewModelTests: XCTestCase {

    var service: MockActivityService!
    var cardService: MockCardsService!
    var viewModel: ActivityViewModel!
    
    override func setUp() {
        self.service = MockActivityService()
        self.cardService = MockCardsService()
        self.viewModel = ActivityViewModel(manager: self.service, cardManager: self.cardService)
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
    
    @MainActor func testGetCardsWithError() async {
        cardService.fetchCardsError = true
        var expectation = expectation(description: "Error fetching cards")
        viewModel.getCards()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetCardsWithSuccess() async {
        cardService.fetchCardsError = false
        var expectation = expectation(description: "No Error")
        viewModel.getCards()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            XCTAssertNotNil(self.viewModel.selectedCard)
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    // even with error no message is thrown in view model not to distruct the user
//    @MainActor func testGetActivityWithError() async {
//        service.fetchActivityError = true
//        var expectation = expectation(description: "Error fetching activity")
//        viewModel.getActivity()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            self.checkError(expectation: &expectation)
//        })
//        
//        await fulfillment(of: [expectation], timeout: 3)
//    }
    
    @MainActor func testGetActivityWithSuccess() async {
        service.fetchActivityError = false
        var expectation = expectation(description: "No Error")
        viewModel.getActivity()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            XCTAssertNotNil(self.viewModel.activity)
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }

}
