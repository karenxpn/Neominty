//
//  HomeViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import XCTest
@testable import Banking

final class HomeViewModelTests: XCTestCase {

    var cardService: MockCardsService!
    var transferService: MockTransferService!
    var notificationService: MockNotificationService!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        self.cardService = MockCardsService()
        self.transferService = MockTransferService()
        self.notificationService = MockNotificationService()
        
        self.viewModel = HomeViewModel(
            transferManager: self.transferService,
            cardManager: self.cardService,
            notificationManager: self.notificationService
        )
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
            XCTAssertFalse(self.viewModel.cards.isEmpty)
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetRecentTransfersWithError() async {
        transferService.fetchRecentTransferHistoryError = true
        var expectation = expectation(description: "Error fetching recent transfers history")
        viewModel.getRecentTransfers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetRecentTransfersWithSuccess() async {
        transferService.fetchRecentTransferHistoryError = false
        var expectation = expectation(description: "No Error")
        viewModel.getRecentTransfers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
}
