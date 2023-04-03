//
//  UserInfo.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import Foundation
struct UserInfo: Codable {
    var image: String?
    var name: String
    var email: String?
    var phoneNumber: PhoneModel
}

struct PhoneModel: Codable {
    var code: String
    var number: String
}

struct UserInfoViewModel {
    var model: UserInfo
    init(model: UserInfo) {
        self.model = model
    }
    
    func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }
    
    var image: String?      { self.model.image }
    var name: String        { self.model.name }
    var email: String?      { self.model.email }
    var flag: String        { countryFlag(countryCode: self.model.phoneNumber.code )}
    var phone: String       { self.model.phoneNumber.number }
}
