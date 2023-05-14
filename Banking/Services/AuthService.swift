//
//  AuthService.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AuthServiceProtocol {
    func sendVerificationCode(phone: String) async -> Result<Void, Error>
    func checkVerificationCode(code: String) async -> Result<(String, String), Error>
    func fetchIntroduction() async -> Result<[IntroductionModel], Error>
    func signOut() async -> Result<Void, Error>
}

class AuthService {
    static let shared: AuthServiceProtocol = AuthService()
    let db = Firestore.firestore()
    private init() { }
}


extension AuthService: AuthServiceProtocol {
    
    func signOut() async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try Auth.auth().signOut()
        }
    }
    
    func sendVerificationCode(phone: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil)
            UserDefaults.standard.set( verificationID, forKey: "authVerificationID")
        }
    }
    
    func checkVerificationCode(code: String) async -> Result<(String, String), Error> {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        guard let verificationID else { return .failure(Error.self as! Error) }
        
        do {
            let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            let uid = try await Auth.auth().signIn(with: credential).user.uid
            let fullName = try await db.collection(Paths.users.rawValue)
                .document(uid)
                .getDocument(as: UserInfo.self)
                .name ?? ""
                
            return .success((uid, fullName))
            
        } catch {
            return .failure(error)
        }
    }
    
    func fetchIntroduction() async -> Result<[IntroductionModel], Error> {
        do {
            let result = try await db.collection(Paths.introduction.rawValue)
                .getDocuments()
                .documents.map({ try $0.data(as: IntroductionModel.self)})
            
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    

}
