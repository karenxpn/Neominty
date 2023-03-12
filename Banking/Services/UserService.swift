//
//  UserService.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func checkPinExistence(userID: String) async -> Result<String, Error>
    func storePin(userID: String, pin: String) async -> Result<Void, Error>
}

class UserSerive {
    static let shared: UserServiceProtocol = UserSerive()
    let db = Firestore.firestore()
    private init() { }
}

extension UserSerive: UserServiceProtocol {
    func checkPinExistence(userID: String) async -> Result<String, Error> {
        do {
            let result = try await db.collection(Paths.pins.rawValue).document(userID).getDocument(as: PinModel.self)
            return .success(result.pin)
        } catch {
            return .failure(error)
        }
    }
    
    func storePin(userID: String, pin: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            let _ = try await db.collection(Paths.pins.rawValue).document(userID).setData(["pin" : pin])
        }
    }
}
