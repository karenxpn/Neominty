//
//  NotificationsViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 19.01.24.
//

import XCTest
@testable import Banking

final class NotificationsViewModelTests: XCTestCase {

    var service: MockNotificationService!
    var viewModel: NotificationsViewModel!
    
    override func setUp() {
        self.service = MockNotificationService()
        self.viewModel = NotificationsViewModel(manager: self.service)
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
    
    @MainActor func testGetNotificationsWithError() async {
        service.fetchNotificationsError = true
        var expectation = expectation(description: "Error fetching notifications")
        viewModel.getNotifications()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation)
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetNotificationsWithSuccess() async {
        service.fetchNotificationsError = false
        var expectation = expectation(description: "No error")
        viewModel.getNotifications()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testMarkAllAsReadWithError() async {
        service.markAllAsReadError = true
        var expectation = expectation(description: "Error when trying to mark all notifications as read")
        viewModel.markAsRead()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkError(expectation: &expectation)
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testMarkAllAsReadWithSuccess() async {
        service.markAllAsReadError = false
        var expectation = expectation(description: "No error")
        viewModel.markAsRead()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        await fulfillment(of: [expectation], timeout: 3)
    }
}
