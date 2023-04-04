//
//  UserService.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func fetchAccountInfo() async -> Result<UserInfo, Error>
    func updateAccountInfo(name: String, email: String?) async -> Result<Void, Error>
    func updateEmailPreferences(receive: Bool) async -> Result<Void, Error>
    func updateNotificationsPreferences(receive: Bool) async -> Result<Void, Error>
    func fetchUserPreferences() async -> Result<UserPreferences, Error>
    func fetchFaqs(page: Int) async -> Result<[FAQModel], Error>
}

class UserSerive {
    static let shared: UserServiceProtocol = UserSerive()
    let db = Firestore.firestore()
    private init() { }
}

extension UserSerive: UserServiceProtocol {
    
    func fetchFaqs(page: Int) async -> Result<[FAQModel], Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            var faqs = [FAQModel]()
            if page <= 2 {
                faqs = [PreviewModels.faqList[page]]
            }
            return .success(faqs)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchUserPreferences() async -> Result<UserPreferences, Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            let preferences = UserPreferences(receiveNotifications: false, receiveEmails: true)
            return .success(preferences)
        } catch {
            return .failure(error)
        }
    }
    
    func updateEmailPreferences(receive: Bool) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        }
    }
    
    func updateNotificationsPreferences(receive: Bool) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        }
    }
    
    func updateAccountInfo(name: String, email: String?) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
        }
    }
    
    func fetchAccountInfo() async -> Result<UserInfo, Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            let user = UserInfo(name: "Karen Mirakyan", phoneNumber: PhoneModel(code: "AM", number: "93936313"))
            return .success(user)
        } catch {
            return .failure(error)
        }
    }

}
