//
//  AccountPaths.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.25.
//

import Foundation

enum AccountViewPaths: Equatable, Hashable {
    case info(name: String?, flag: String?, phone: String?, email: String?)
    case accountEmail(email: String?)
    case settings
    case changePin
    case faq
    case allFaq
    case verifyAccount
    case accountRejected
    case accountVerified
}
