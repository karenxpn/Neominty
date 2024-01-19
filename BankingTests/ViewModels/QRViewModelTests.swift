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
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testPerformPaymentWithError() async {
        payService.bindingToBindingError = true
        var expectation = expectation(description: "Error performing binding to binding payment")
        viewModel.selectedCard = PreviewModels.amexCard
        viewModel.performPayment(receiver: "", amount: "") { }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)        
    }

    @MainActor func testPerformPaymentWithSuccess() async {
        payService.bindingToBindingError = false
        var expectation = expectation(description: "No Error")
        viewModel.selectedCard = PreviewModels.amexCard
        viewModel.performPayment(receiver: "", amount: "") { }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)

    }
}
