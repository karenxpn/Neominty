//
//  AccountViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 18.01.24.
//

import XCTest
@testable import Banking

final class AccountViewModelTests: XCTestCase {

    var service: MockAccountService!
    var viewModel: AccountViewModel!
    
    override func setUp() {
        self.service = MockAccountService()
        self.viewModel = AccountViewModel(manager: self.service)
    }
    
    func testGetAccountInfoWithError() async {
        service.fetchInfoError = true
        await wait(for: { await self.viewModel.getAccountInfo() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching account info")
    }
    
    func testGetAccountInfoWithSuccess() async {
        service.fetchInfoError = false
        await wait(for: { await self.viewModel.getAccountInfo() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    
    func testUpdateAccountInfoWithError() async {
        service.updateInfoError = true
        await wait(for: { await self.viewModel.updateInfo(name: "") })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error updating account info")
    }
    
    func testUpdateAccountInfoWithSuccess() async {
        service.updateInfoError = false
        await wait(for: { await self.viewModel.updateInfo(name: "" ) })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    
    func testUpdateEmailPreferencesWithError() async {
        service.updateEmailPreferenceError = true
        // checking for success cause no error is displaied to the user if something is wrong
        await wait(for: { await self.viewModel.updateEmailPreference(receive: true ) })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
        
    }
    
    func testUpdateEmailPreferencesWithSuccess() async {
        service.updateEmailPreferenceError = false
        await wait(for: { await self.viewModel.updateEmailPreference(receive: true ) })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }

    func testUpdateNotificationPreferencesWithError() async {
        service.updateNotificationPreferenceError = true
        await wait(for: { await self.viewModel.updateNotificationPreference(receive: true) })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    
    func testUpdateUpdateNotificationPreferencesWithSuccess() async {
        service.updateNotificationPreferenceError = false
        await wait(for: { await self.viewModel.updateNotificationPreference(receive: true) })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    
    func testUpdateAvatarWithError() async {
        service.updateAvatarError = true
        await wait(for: { await self.viewModel.updateAvatar(image: Data()) })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error updating avatar")
    }
    
    func testUpdateAvatarWithSuccess() async {
        service.updateAvatarError = false
        await wait(for: { await self.viewModel.updateAvatar(image: Data()) })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    
    func testGetUserPreferencesWithError() async {
        service.fetchPreferencesError = true
        await wait(for: { await self.viewModel.getPreferences() })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error fetching user preferences")
    }
    
    func testGetUserPreferencesWithSuccess() async {
        service.fetchPreferencesError = false
        await wait(for: { await self.viewModel.getPreferences() })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    

    func testUpdateEmailWithError() async {
        service.updateEmailError = true
        await wait(for: { await self.viewModel.updateEmail(email: "") })

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Error updating email")
    }
    
    func testUpdateEmailWithSuccess() async {
        service.updateEmailError = false
        await wait(for: { await self.viewModel.updateEmail(email: "") })

        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
    }
    
}
