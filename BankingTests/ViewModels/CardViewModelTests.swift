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
    
    func testGetCardsWithError() async {
        service.fetchCardsError = true
        await wait(for: { await self.viewModel.getCards() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching cards")
    }
    
    func testGetCardsWithSuccess() async {
        service.fetchCardsError = false
        await wait(for: { await self.viewModel.getCards() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertEqual(viewModel.cards[0].cardType, CardType.masterCard)
    }
    
    func testDeleteCardWithError() async {
        service.removeCardError = true
        await wait(for: { await self.viewModel.deleteCard(id: "") })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error removing your card")
        
    }
    
    func testDeleteCardWithSuccess() async {
        service.removeCardError = false
        
        await wait(for: {
            self.viewModel.cards.append(PreviewModels.amexCard)
            await self.viewModel.deleteCard(id: self.viewModel.cards[0].id ?? "1")
        })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertTrue(viewModel.cards.isEmpty)
    }
    
    func testRegisterOrderWithError() async {
        service.registerOrderError = true
        await wait(for: { await self.viewModel.registerOrder() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error registering new order")
    }
    
    func testRegisterOrderWithSuccess() async {
        service.registerOrderError = false
        await wait(for: { await self.viewModel.registerOrder() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertEqual(viewModel.orderID, "123")

    }
    
    func testAttachCardWithError() async {
        service.attachCardError = true
        await wait(for: { await self.viewModel.getAttachmentStatus() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error attaching new card")
    }
    
    func testAttachCardWithSuccess() async {
        service.attachCardError = false
        await wait(for: { await self.viewModel.getAttachmentStatus() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
}
