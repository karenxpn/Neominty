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
    
    func checkSuccess(expectation: inout XCTestExpectation) {
        XCTAssertFalse(viewModel.showAlert)
        if !self.viewModel.showAlert {
            XCTAssertTrue(self.viewModel.alertMessage.isEmpty)
            expectation.fulfill()
        }
    }
    
    func checkError(expectation: inout XCTestExpectation, message: String) {
        XCTAssertTrue(viewModel.showAlert)
        if viewModel.showAlert {
            XCTAssertEqual(viewModel.alertMessage, message)
            expectation.fulfill()
        }
    }
    
    
    @MainActor func testGetAccountInfoWithError() async {
        service.fetchInfoError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.getAccountInfo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error fetching account info")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetAccountInfoWithSuccess() async {
        service.fetchInfoError = false
        var expectation = expectation(description: "No Error")
        viewModel.getAccountInfo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateAccountInfoWithError() async {
        service.updateInfoError = true
        var expectation = expectation(description: "Error alert expectation")

        viewModel.updateInfo(name: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error updating account info")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateAccountInfoWithSuccess() async {
        service.updateInfoError = false
        var expectation = expectation(description: "No Error")
        viewModel.updateInfo(name: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateEmailPreferencesWithError() async {
        service.updateEmailPreferenceError = true
        var expectation = expectation(description: "Error alert expectation")

        viewModel.updateEmailPreference(receive: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            // checking for success cause no error is displaied to the user if something is wrong
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateEmailPreferencesWithSuccess() async {
        service.updateEmailPreferenceError = false
        var expectation = expectation(description: "No Error")
        viewModel.updateEmailPreference(receive: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }

    @MainActor func testUpdateNotificationPreferencesWithError() async {
        service.updateNotificationPreferenceError = true
        var expectation = expectation(description: "Error alert expectation")

        viewModel.updateNotificationPreference(receive: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            // checking for success cause no error is displaied to the user if something is wrong
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateUpdateNotificationPreferencesWithSuccess() async {
        service.updateNotificationPreferenceError = false
        var expectation = expectation(description: "No Error")
        viewModel.updateNotificationPreference(receive: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateAvatarWithError() async {
        service.updateAvatarError = true
        
        var expectation = expectation(description: "Error alert expectation")

        viewModel.updateAvatar(image: Data())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error updating avatar")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateAvatarWithSuccess() async {
        service.updateAvatarError = false
        var expectation = expectation(description: "No Error")
        viewModel.updateAvatar(image: Data())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetUserPreferencesWithError() async {
        service.fetchPreferencesError = true
        var expectation = expectation(description: "Error alert expectation")

        viewModel.getPreferences()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error fetching user preferences")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testGetUserPreferencesWithSuccess() async {
        service.fetchPreferencesError = false
        var expectation = expectation(description: "No Error")
        viewModel.getPreferences()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    

    @MainActor func testUpdateEmailWithError() async {
        service.updateEmailError = true
        var expectation = expectation(description: "Error alert expectation")

        viewModel.updateEmail(email: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error updating email")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testUpdateEmailWithSuccess() async {
        service.updateEmailError = false
        var expectation = expectation(description: "No Error")
        viewModel.updateEmail(email: "")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
}
