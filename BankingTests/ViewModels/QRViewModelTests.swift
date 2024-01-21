//
//  QRViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import XCTest
@testable import Banking

final class QRViewModelTests: XCTestCase {

    var payService: MockPayService!
    var cardService: MockCardsService!
    var viewModel: QrViewModel!
    
    override func setUp() {
        self.payService = MockPayService()
        self.cardService = MockCardsService()
        
        self.viewModel = QrViewModel(cardManager: self.cardService, payManager: self.payService)
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
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    
    func testPerformPaymentWithError() async {
        payService.bindingToBindingError = true
        await wait {
            self.viewModel.selectedCard = PreviewModels.amexCard
            await self.viewModel.performPayment(receiver: "", amount: "") { }
        }
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error performing binding to binding payment")
    }

    func testPerformPaymentWithSuccess() async {
        payService.bindingToBindingError = false
        await wait {
            self.viewModel.selectedCard = PreviewModels.amexCard
            await self.viewModel.performPayment(receiver: "", amount: "") { }
        }
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
}


extension XCTestCase {
    @MainActor func wait(for task: @escaping @Sendable () async throws -> Void, timeout: TimeInterval = 5) async {
        let expectation = XCTestExpectation(description: "Async task completion")
        
        Task {
            do {
                try await task()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
}
