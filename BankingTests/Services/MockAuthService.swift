//
//  MockAuthService.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 18.01.24.
//

import Foundation
@testable import Banking

class MockAuthService: AuthServiceProtocol {
    var sendVerificationError: Bool = false
    var checkVerificationError: Bool = false
    var fetchIntroError: Bool = false
    var signOutError: Bool = false
    
    func sendVerificationCode(phone: String) async -> Result<Void, Error> {
        if sendVerificationError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error sending Verification Code"]))
        } else {
            return .success(())
        }
    }
    
    func checkVerificationCode(code: String) async -> Result<String, Error> {
        if checkVerificationError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Invalid OTP"]))
        } else {
            return .success("userUID")
        }
    }
    
    func fetchIntroduction() async -> Result<[IntroductionModel], Error> {
        if fetchIntroError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching introduction"]))
        } else {
            return .success([PreviewModels.introduction])
        }
    }
    
    func signOut() async -> Result<Void, Error> {
        if signOutError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error signing out"]))
        } else {
            return .success(())
        }
    }
}
