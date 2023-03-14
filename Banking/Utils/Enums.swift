//
//  Enums.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI
enum Paths : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case introduction
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .introduction,
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .introduction                      : return "introduction"
        case let .unknown(value)                : return value
        }
    }
}


enum Roboto : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case bold
    case black
    case light
    case regular
    case medium
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .bold,
        .regular,
        .light,
        .black,
        .medium
        
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .bold                      : return "Roboto-Bold"
        case .black                     : return "Roboto-Black"
        case .regular                   : return "Roboto-Regular"
        case .light                     : return "Roboto-Light"
        case .medium                    : return "Roboto-Medium"
        case let .unknown(value)                : return value
        }
    }
}


enum ViewPaths: Codable {
    
//    typealias RawValue = String
    
    case setPasscode
    case confirmPasscode
    case enableBiometric
    case verifyPhoneNumber
//    case unknown(RawValue)
//
//    static let allCases: AllCases = [
//        .setPasscode,
//        .confirmPasscode,
//        .enableBiometric,
//        .forgorPasscode,
//        .verifyPhoneNumber
//    ]
//
//    init(rawValue: RawValue) {
//        self = Self.allCases.first{ $0.rawValue == rawValue }
//        ?? .unknown(rawValue)
//    }
//
//    var rawValue: RawValue {
//        switch self {
//        case .setPasscode                       : return "setPasscode"
//        case .confirmPasscode                   : return "confirmPasscode"
//        case .enableBiometric                   : return "enableBiometric"
//        case .forgorPasscode                    : return "forgotPasscode"
//        case .verifyPhoneNumber                 : return "verifyPhoneNumber"
//        case let .unknown(value)                : return value
//        }
//    }
}


enum AuthenticationState {
    case notDetermind
    case setPasscode
    case enterPasscode
    case authenticated
}
