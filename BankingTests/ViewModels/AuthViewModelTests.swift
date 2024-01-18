//
//  AuthViewModelTests.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 18.01.24.
//

import XCTest
@testable import Banking

final class AuthViewModelTests: XCTestCase {

    var service: MockAuthService!
    var viewModel: AuthViewModel!
    
    override func setUp() {
        self.service = MockAuthService()
        self.viewModel = AuthViewModel(manager: self.service)
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
    
    @MainActor func testSendVerificatioinWithError() async {
        service.sendVerificationError = true
        var expectation = expectation(description: "Error alert expectation")

        viewModel.sendVerificationCode()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error sending Verification Code")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testSendVerificationCodeWithSuccess() async {
        service.sendVerificationError = false
        var expectation = expectation(description: "No Error")
        
        viewModel.sendVerificationCode()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testCheckVerificationCodeWithError() async {
        service.checkVerificationError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.checkVerificationCode()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Invalid OTP")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testCheckVerificationCodeWithSuccess() async {
        service.checkVerificationError = false
        var expectation = expectation(description: "No Error")
        viewModel.checkVerificationCode()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testFetchIntroWithError() async {
        service.fetchIntroError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.getIntroductionPages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error fetching introduction")
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testFetchIntroWithSuccess() async {
        service.fetchIntroError = false
        
        var expectation = expectation(description: "No Error")
        viewModel.getIntroductionPages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    @MainActor func testSignOutWithError() async {
        service.signOutError = true
        var expectation = expectation(description: "Error alert expectation")
        viewModel.signOut()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkError(expectation: &expectation, message: "Error signing out")
        })
        
        await fulfillment(of: [expectation], timeout: 3)

    }
    
    @MainActor func testSignOutWithSuccess() async {
        service.signOutError = false
        var expectation = expectation(description: "No Error")
        viewModel.signOut()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.checkSuccess(expectation: &expectation)
        })
        
        await fulfillment(of: [expectation], timeout: 3)
    }
}
