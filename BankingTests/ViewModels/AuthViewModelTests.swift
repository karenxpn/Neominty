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
            XCTAssertFalse(viewModel.alertMessage.isEmpty)
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
}
