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
    
    func testGetAllTransfersWithError() async {
        service.fetchTransactionHistoryError = true
        await wait(for: { await self.viewModel.getTransactionList() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching history")

    }
    
    func testGetAllTransfersWithSuccess() async {
        service.fetchTransactionHistoryError = false
        await wait(for: { await self.viewModel.getTransactionList() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
}
