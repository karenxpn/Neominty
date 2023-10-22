//
//  UserInfo.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import Foundation
import PhoneNumberKit

struct UserInfo: Codable {
    var id: String
    var avatar: String?
    var name: String?
    var email: EmailModel?
    var phone_number: String?
    var isVerified: Bool?
}

struct EmailModel: Codable {
    var email: String?
    var verified: Bool
}

struct UserInfoViewModel: Identifiable {
    var model: UserInfo
    init(model: UserInfo) {
        self.model = model
    }
    
    var id: String  { self.model.id }
    func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }
    
    let phoneNumberKit = PhoneNumberKit()
    
    func getCountryCode() -> String {
        
        do {
            let phoneNumber = try phoneNumberKit.parse(self.model.phone_number ?? "")
            return "\(phoneNumberKit.mainCountry(forCode: phoneNumber.countryCode)!)"
        }
        catch {
            print("Generic parser error")
            return ""
        }
    }
    
    func getNationalNumber() -> String {
        do {
            let phoneNumber = try phoneNumberKit.parse(self.model.phone_number ?? "")
            return "\(phoneNumber.nationalNumber)"
        }
        catch {
            print("Generic parser error")
            return ""
        }
    }
    
    var avatar: String?     { self.model.avatar }
    var name: String?       { self.model.name }
    var email: String?      { self.model.email?.email }
    var flag: String        { countryFlag(countryCode: getCountryCode())}
    var phone: String?      { getNationalNumber() }
    var isVerified: Bool?   { self.model.isVerified }
}
