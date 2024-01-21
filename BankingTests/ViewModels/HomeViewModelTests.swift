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
    
    func testGetCardsWithError() async {
        cardService.fetchCardsError = true
        await wait(for: { await self.viewModel.getCards() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching cards")
    }
    
    func testGetCardsWithSuccess() async {
        cardService.fetchCardsError = false
        await wait(for: { await self.viewModel.getCards() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertFalse(self.viewModel.cards.isEmpty)

    }
    
    func testGetRecentTransfersWithError() async {
        transferService.fetchRecentTransferHistoryError = true
        await wait(for: { await self.viewModel.getRecentTransfers() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching recent transfers history")
    }
    
    func testGetRecentTransfersWithSuccess() async {
        transferService.fetchRecentTransferHistoryError = false
        await wait(for: { await self.viewModel.getRecentTransfers() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
}
