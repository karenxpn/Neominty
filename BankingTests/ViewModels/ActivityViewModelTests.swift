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
        XCTAssertEqual(viewModel.cards[0].cardType, CardType.masterCard)
        XCTAssertNotNil(self.viewModel.selectedCard)
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
    
    func testGetActivityWithSuccess() async {
        service.fetchActivityError = false
        await wait(for: { await self.viewModel.getActivity() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertNotNil(self.viewModel.activity)
    }

}
