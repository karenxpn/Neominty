//
//  KeychainManager.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import Foundation
import KeychainSwift

class KeychainManager {
    static let shared = KeychainSwift()
    private init() { }
}

extension KeychainManager {
    func set(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query = [kSecClass: kSecClassGenericPassword,
                         kSecAttrAccount: key,
                         kSecValueData: data] as [String: Any]
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Error saving to Keychain: \(status)")
            }
        }
    }
    
    func get(_ key: String) -> String? {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: key,
                     kSecReturnData: kCFBooleanTrue,
                     kSecMatchLimit: kSecMatchLimitOne] as [String: Any]
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        } else {
            print("Error reading from Keychain: \(status)")
        }
        return nil
    }
}
