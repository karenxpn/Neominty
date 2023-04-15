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

enum AuthenticationState {
    case notDetermind
    case setPasscode
    case enterPasscode
    case authenticated
}

enum ActivityUnit : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case day
    case week
    case month
    case year
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .day,
        .week,
        .month,
        .year,
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .day                       : return "day"
        case .week                      : return "week"
        case .month                     : return "month"
        case .year                      : return "year"
        case let .unknown(value)        : return value
        }
    }
}

enum RequestType: String, Identifiable {
    case phone, email, link
    
    var id: String {
        self.rawValue
    }
    
    var image: String {
        switch self {
        case .phone:
            return "phone"
        case .link:
            return "link"
        case .email:
            return "envelope"
        }
    }
}

enum PinAuthenticationType {
    case authenticate
    case pass
}

enum NotificationName: RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case pinPassed
    case requestPaymentSent
    case infoUpdated
    case paymentCompleted
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .pinPassed,
        .requestPaymentSent,
        .infoUpdated,
        .paymentCompleted
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .pinPassed                         : return "pinPassed"
        case .requestPaymentSent                : return "requestPaymentSent"
        case .infoUpdated                       : return "acountInfoUpdated"
        case .paymentCompleted                  : return "paymentCompleted"
        case let .unknown(value)                : return value
        }
    }
}

enum NotificationType: RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case reward
    case request
    case transfer
    case payment
    case cashback
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .reward,
        .request,
        .transfer,
        .payment,
        .cashback
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .reward                       : return "Reward"
        case .request                      : return "Request"
        case .transfer                     : return "Transfer"
        case .payment                      : return "Payment"
        case .cashback                     : return "Cashback"
        case let .unknown(value)        : return value
        }
    }
}
