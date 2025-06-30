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
    func fetchFaqs(lastDoc: QueryDocumentSnapshot?) async -> Result<([FAQModel], QueryDocumentSnapshot?), Error>
    func updateEmail(userID: String, email: String) async -> Result<Void, Error>
}

class UserSerive {
    static let shared: UserServiceProtocol = UserSerive()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    private init() { }
}

extension UserSerive: UserServiceProtocol {
    func fetchFaqs(lastDoc: QueryDocumentSnapshot?) async -> Result<([FAQModel], QueryDocumentSnapshot?), Error> {
        do {
            var query: Query = db.collection(Paths.faqs.rawValue)
            
            if lastDoc == nil   { query = query.limit(to: 30) }
            else                { query = query.start(afterDocument: lastDoc!).limit(to: 30) }
            
            let docs = try await query.getDocuments().documents
            let faqs = try docs.map { try $0.data(as: FAQModel.self ) }
            
            return .success((faqs, docs.last))
        } catch {
            print("error \(error.localizedDescription)")
            return .failure(error)
        }
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
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name

            try await db.collection(Paths.users.rawValue).document(userID).updateData(["name": name])
            try await changeRequest?.commitChanges()
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
                try await user.sendEmailVerification(beforeUpdatingEmail: email)
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
