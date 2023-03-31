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
}

class UserSerive {
    static let shared: UserServiceProtocol = UserSerive()
    let db = Firestore.firestore()
    private init() { }
}

extension UserSerive: UserServiceProtocol {
    
    func fetchAccountInfo() async -> Result<UserInfo, Error> {
        do {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            let user = UserInfo(name: "Karen Mirakyan")
            return .success(user)
        } catch {
            return .failure(error)
        }
    }

}
