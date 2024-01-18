//
//  MockAccountService.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 18.01.24.
//

import Foundation
@testable import Banking

class MockAccountService: UserServiceProtocol {
    var fetchInfoError: Bool = false
    var updateInfoError: Bool = false
    var updateEmailPreferenceError: Bool = false
    var updateNotificationPreferenceError: Bool = false
    var updateAvatarError: Bool = false
    var fetchPreferencesError: Bool = false
    var fetchFAQError: Bool = false
    var updateEmailError: Bool = false
    
    func fetchAccountInfo(userID: String) async -> Result<UserInfo, Error> {
        if fetchInfoError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching account info"]))
        } else {
            return .success(PreviewModels.userInfo.model)
        }
    }
    
    func updateAccountInfo(userID: String, name: String) async -> Result<Void, Error> {
        if updateInfoError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error updating account info"]))
            
        } else {
            return .success(())
        }
    }
    
    func updateEmailPreferences(userID: String, receive: Bool) async -> Result<Void, Error> {
        if updateEmailPreferenceError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error updating user email preference"]))
            
        } else {
            return .success(())
        }
    }
    
    func updateNotificationsPreferences(userID: String, receive: Bool) async -> Result<Void, Error> {
        if updateNotificationPreferenceError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error updating user notification preference"]))
            
        } else {
            return .success(())
        }
    }
    
    func updateAvatar(userID: String, image: Data) async -> Result<Void, Error> {
        if updateAvatarError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error updating avatar"]))
            
        } else {
            return .success(())
        }
    }
    
    func fetchUserPreferences(userID: String) async -> Result<UserPreferences, Error> {
        if fetchPreferencesError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching user preferences"]))
            
        } else {
            return .success(PreviewModels.userPreferences)
        }
    }
    
    func fetchFaqs(query: String, page: Int) async throws -> FAQListModel {
        if fetchFAQError {
            throw NSError(domain: "Error",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Error fetching FAQs"])
            
        } else {
            return FAQListModel(hits: PreviewModels.faqList)
        }
    }
    
    func updateEmail(userID: String, email: String) async -> Result<Void, Error> {
        if updateEmailError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching FAQs"]))
        } else {
            return .success(())
        }
    }
}
