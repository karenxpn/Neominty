//
//  AuthService.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func sendVerificationCode(phone: String) async -> Result<Void, Error>
    func checkVerificationCode(code: String) async -> Result<String, Error>
}

class AuthService {
    static let shared: AuthServiceProtocol = AuthService()
    private init() { }
}


extension AuthService: AuthServiceProtocol {
    func sendVerificationCode(phone: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil)
            UserDefaults.standard.set( verificationID, forKey: "authVerificationID")
        }
    }
    
    func checkVerificationCode(code: String) async -> Result<String, Error> {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        guard let verificationID else { return .failure(Error.self as! Error) }
        
        do {
            let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            let uid = try await Auth.auth().signIn(with: credential).user.uid
            return .success(uid)
            
        } catch {
            return .failure(error)
        }
    }
}
