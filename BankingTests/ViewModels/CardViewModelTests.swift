//
//  CardViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 18.01.24.
//

import XCTest
@testable import Banking

final class CardViewModelTests: XCTestCase {

    var service: MockCardsService!
    var viewModel: CardsViewModel!
    
    override func setUp() {
        self.service = MockCardsService()
        self.viewModel = CardsViewModel(manager: self.service)
    }
    
    func checkError(expectation: inout XCTestExpectation, message: String) {
        XCTAssertTrue(viewModel.showAlert)
        if viewModel.showAlert {
            XCTAssertEqual(viewModel.alertMessage, message)
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
        service.fetchCardsError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.getCards()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation, message: "Error fetching cards")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetCardsWithSuccess() async {
        service.fetchCardsError = false
        var expectation = expectation(description: "No Error")
        viewModel.getCards()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            XCTAssertEqual(self.viewModel.cards[0].cardType, CardType.masterCard)
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)

    }
    
    @MainActor func testDeleteCardWithError() async {
        service.removeCardError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.deleteCard(id: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation, message: "Error removing your card")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testDeleteCardWithSuccess() async {
        service.removeCardError = false
        var expectation = expectation(description: "No Error")
        viewModel.cards.append(PreviewModels.amexCard)
        viewModel.deleteCard(id: viewModel.cards[0].id ?? "1")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            XCTAssertTrue(self.viewModel.cards.isEmpty)
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testRegisterOrderWithError() async {
        service.registerOrderError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.registerOrder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation, message: "Error registering new order")
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testRegisterOrderWithSuccess() async {
        service.registerOrderError = false
        var expectation = expectation(description: "No Error")
        viewModel.registerOrder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            XCTAssertEqual(self.viewModel.orderID, "123")
            self.checkSuccess(expectation: &expectation)
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testAttachCardWithError() async {
        service.attachCardError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.getAttachmentStatus()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation, message: "Error attaching new card")
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testAttachCardWithSuccess() async {
        service.attachCardError = false
        var expectation = expectation(description: "No Error")
        viewModel.getAttachmentStatus()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
    
}
