//
//  UserService.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Alamofire
import Combine
import FirebaseAuth

protocol UserServiceProtocol {
    func fetchAccountInfo(userID: String) async -> Result<UserInfo, Error>
    func updateAccountInfo(userID: String, name: String) async -> Result<Void, Error>
    func updateEmailPreferences(userID: String, receive: Bool) async -> Result<Void, Error>
    func updateNotificationsPreferences(userID: String, receive: Bool) async -> Result<Void, Error>
    func updateAvatar(userID: String, image: Data) async -> Result<Void, Error>
    func fetchUserPreferences(userID: String) async -> Result<UserPreferences, Error>
    func fetchFaqs(query: String, page: Int) async throws -> FAQListModel
    func updateEmail(userID: String, email: String) async -> Result<Void, Error>
}

class UserSerive {
    static let shared: UserServiceProtocol = UserSerive()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    private init() { }
}

extension UserSerive: UserServiceProtocol {
    func fetchFaqs(query: String, page: Int) async throws -> FAQListModel {
        let url = URL(string: "https://\(Credentials.algolia_app_id)-dsn.algolia.net/1/indexes/faqs/query")!
        let headers: HTTPHeaders = ["X-Algolia-Application-Id": Credentials.algolia_app_id,
                                    "X-Algolia-API-Key": Credentials.algolia_api_key]
        
        let params: Parameters = [ "params" : "query=\(query)&hitsPerPage=5&page=\(page)" ]
        
        return try await withUnsafeThrowingContinuation({ continuation in
            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: headers)
            .validate()
            .responseDecodable(of: FAQListModel.self) { response in

                if response.error != nil {
                    response.error.map { err in
                        let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                        continuation.resume(throwing: NetworkError(initialError: err, backendError: backendError))
                    }
                }
                
                if let faqs = response.value {
                    continuation.resume(returning: faqs)
                }
            }
        })
    }
    
    
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
    
    func updateAccountInfo(userID: String, name: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(Paths.users.rawValue).document(userID).updateData(["name": name])            
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
    
    func updateEmail(userID: String, email: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest(action: {
            let actionCodeSettings =  ActionCodeSettings.init()
            actionCodeSettings.handleCodeInApp = false
            actionCodeSettings.url = URL(string: "https://neominty.page.link/email")
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            let user = Auth.auth().currentUser
                       
            if let user {
                try await user.updateEmail(to: email)
                if !user.isEmailVerified {
                    print("This email is not verified")
                    try await user.sendEmailVerification(with: actionCodeSettings)
                    try await db.collection(Paths.users.rawValue).document(userID).updateData(
                        ["email": ["email" : email,
                                   "verified": user.isEmailVerified]]
                    )
                }
            }
        })
    }
    
}
