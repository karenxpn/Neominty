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
    case users
    case notifications
    case cards
    case orderRules
    case defaultCard
    case transactions
    case payments
    case userTransferActivity
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .introduction,
        .users,
        .notifications,
        .cards,
        .orderRules,
        .defaultCard,
        .transactions,
        .payments,
        .userTransferActivity
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .introduction                      : return "introduction"
        case .users                             : return "users"
        case .notifications                     : return "notifications"
        case .cards                             : return "cards"
        case .defaultCard                       : return "defaultCard"
        case .orderRules                        : return "orderRules"
        case .transactions                      : return "transactions"
        case .payments                          : return "payments"
        case .userTransferActivity              : return "userTransferActivity"
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
    case orderRegistered
    case cardAttached
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .pinPassed,
        .requestPaymentSent,
        .infoUpdated,
        .paymentCompleted,
        .orderRegistered,
        .cardAttached
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
        case .orderRegistered                   : return "orderRegistered"
        case .cardAttached                      : return "cardAttached"
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


enum FieldKeyboardType: RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case numbers
    case phone
    case keyboard
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .numbers,
        .phone,
        .keyboard
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .numbers                       : return "Numbers"
        case .keyboard                      : return "Keyboard"
        case .phone                         : return "Phone"
        case let .unknown(value)        : return value
        }
    }
}
