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
