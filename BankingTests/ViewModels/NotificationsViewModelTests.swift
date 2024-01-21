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
    
    func testGetNotificationsWithError() async {
        service.fetchNotificationsError = true
        await wait(for: { await self.viewModel.getNotifications() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching notifications")

    }
    
    func testGetNotificationsWithSuccess() async {
        service.fetchNotificationsError = false
        await wait(for: { await self.viewModel.getNotifications() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testMarkAllAsReadWithError() async {
        service.markAllAsReadError = true
        await wait(for: { await self.viewModel.markAsRead() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error when trying to mark all notifications as read")

    }
    
    func testMarkAllAsReadWithSuccess() async {
        service.markAllAsReadError = false
        await wait(for: { await self.viewModel.markAsRead() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
}
