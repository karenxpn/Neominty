//
//  UserService.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol UserServiceProtocol {
    func fetchAccountInfo(userID: String) async -> Result<UserInfo, Error>
    func updateAccountInfo(userID: String, name: String, email: String?) async -> Result<Void, Error>
    func updateEmailPreferences(userID: String, receive: Bool) async -> Result<Void, Error>
    func updateNotificationsPreferences(userID: String, receive: Bool) async -> Result<Void, Error>
    func updateAvatar(userID: String, image: Data) async -> Result<Void, Error>
    func fetchUserPreferences(userID: String) async -> Result<UserPreferences, Error>
    func fetchFaqs(page: Int, search: String) async -> Result<[FAQModel], Error>
}

class UserSerive {
    static let shared: UserServiceProtocol = UserSerive()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    private init() { }
}

extension UserSerive: UserServiceProtocol {
    
    func updateAvatar(userID: String, image: Data) async -> Result<Void, Error> {
        do {
            
            var url: String

            let dbRef = storageRef.child("avatars/\(UUID().uuidString).jpg")
            let _ = try await dbRef.putDataAsync(image)
            url = try await dbRef.downloadURL().absoluteString
            
            try await db.collection(Paths.users.rawValue).document(userID).updateData(["avatar" : url])

            return .success(())
            
        } catch {
            return .failure(error)
        }
    }
    
    
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
            let preferences = try await db.collection(Paths.users.rawValue).document(userID).getDocument().data(as: UserPreferences.self)
            return .success(preferences)
        } catch {
            return .failure(error)
        }
    }
    
    func updateEmailPreferences(userID: String, receive: Bool) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(Paths.users.rawValue).document(userID).updateData(["email_notifications" : receive])
        }
    }
    
    func updateNotificationsPreferences(userID: String, receive: Bool) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(Paths.users.rawValue).document(userID).updateData(["push_notifications" : receive])
        }
    }
    
    func updateAccountInfo(userID: String, name: String, email: String?) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(Paths.users.rawValue).document(userID).updateData(["name": name,
                                                                                       "email": email?.isEmpty ?? true ? nil : email])
        }
    }
    
    func fetchAccountInfo(userID: String) async -> Result<UserInfo, Error> {
        do {
            let user = try await db.collection(Paths.users.rawValue).document(userID).getDocument().data(as: UserInfo.self)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
}
