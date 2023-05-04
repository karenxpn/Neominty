//
//  UserService.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func fetchAccountInfo(userID: String) async -> Result<UserInfo, Error>
    func updateAccountInfo(userID: String, name: String, email: String?) async -> Result<Void, Error>
    func updateEmailPreferences(userID: String, receive: Bool) async -> Result<Void, Error>
    func updateNotificationsPreferences(userID: String, receive: Bool) async -> Result<Void, Error>
    func fetchUserPreferences(userID: String) async -> Result<UserPreferences, Error>
    func fetchFaqs(page: Int, search: String) async -> Result<[FAQModel], Error>
}

class UserSerive {
    static let shared: UserServiceProtocol = UserSerive()
    let db = Firestore.firestore()
    private init() { }
}

extension UserSerive: UserServiceProtocol {
    
    func fetchFaqs(page: Int, search: String) async -> Result<[FAQModel], Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            var faqs = [FAQModel]()
            if page <= 2 {
                faqs = [PreviewModels.faqList[page]]
            }
            return .success(faqs)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchUserPreferences(userID: String) async -> Result<UserPreferences, Error> {
        do {
            let preferences = try await db.collection("users").document(userID).getDocument().data(as: UserPreferences.self)
            return .success(preferences)
        } catch {
            return .failure(error)
        }
    }
    
    func updateEmailPreferences(userID: String, receive: Bool) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("users").document(userID).updateData(["email_notifications" : receive])
        }
    }
    
    func updateNotificationsPreferences(userID: String, receive: Bool) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("users").document(userID).updateData(["push_notifications" : receive])
        }
    }
    
    func updateAccountInfo(userID: String, name: String, email: String?) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection("users").document(userID).updateData(["name": name,
                                                                          "email": email?.isEmpty ?? true ? nil : email])
        }
    }
    
    func fetchAccountInfo(userID: String) async -> Result<UserInfo, Error> {
        do {
            let user = try await db.collection("users").document(userID).getDocument().data(as: UserInfo.self)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }

}
