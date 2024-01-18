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
    
    func testSendVerificatioinWithError() {
        service.sendVerificationError = true
        Task {
            await viewModel.sendVerificationCode()
            
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Error sending Verification Code")
        }
    }
    
    func testSendVerificationCodeWithSuccess() {
        service.sendVerificationError = false
        Task {
            await viewModel.sendVerificationCode()
            
            XCTAssertFalse(viewModel.showAlert)
            XCTAssertTrue(viewModel.alertMessage.isEmpty)
        }
    }
    
    func testCheckVerificationCodeWithError() {
        service.checkVerificationError = true
        
        Task {
            await viewModel.checkVerificationCode()
            
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Invalid OTP")
        }
    }
    
    func testCheckVerificationCodeWithSuccess() {
        service.checkVerificationError = false
        
        Task {
            await viewModel.checkVerificationCode()
            
            XCTAssertFalse(viewModel.showAlert)
            XCTAssertTrue(viewModel.alertMessage.isEmpty)
        }
    }
    
    func testFetchIntroWithError() {
        service.fetchIntroError = true
        Task {
            await viewModel.getIntroductionPages()
            
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.alertMessage, "Error fetching introduction")
            XCTAssertTrue(viewModel.introductionPages.isEmpty)
        }
    }
    
    func testFetchIntroWithSuccess() {
        service.fetchIntroError = false
        
        Task {
            await viewModel.getIntroductionPages()
            
            XCTAssertFalse(viewModel.showAlert)
            XCTAssertTrue(viewModel.alertMessage.isEmpty)
            XCTAssertFalse(viewModel.introductionPages.isEmpty)
        }
    }
    
    func testSignOutWithError() {
        service.signOutError = true
        
        Task {
            await viewModel.signOut()
            
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertFalse(viewModel.alertMessage.isEmpty)
        }
    }
    
    func testSignOutWithSuccess() {
        service.signOutError = false
        Task {
            await viewModel.signOut()
            
            XCTAssertFalse(viewModel.showAlert)
            XCTAssertTrue(viewModel.alertMessage.isEmpty)
        }
    }
}
