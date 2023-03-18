//
//  CardModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation
struct CardModel: Identifiable, Codable {
    var id: String
    var number: String
    var cardHolder: String
    var expirationDate: String
    var design: CardDesign
    var cardType: CardType
}

enum CardType : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case masterCard
    case visa
    case arca
    case amex
    case maestro
    case unionPay
    case mir
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .masterCard,
        .visa,
        .arca,
        .amex,
        .maestro,
        .unionPay,
        .mir
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .masterCard            : return "Master Card"
        case .visa                  : return "Visa"
        case .arca                  : return "ARCA"
        case .amex                  : return "Amex"
        case .maestro               : return "Maestro"
        case .unionPay              : return "Union Pay"
        case .mir                   : return "MIR"
            
            
        case let .unknown(value)    : return value
        }
    }
}


enum CardDesign : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case blue
    case green
    case blueGreen
    case greenBlue
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .blue,
        .green,
        .blueGreen,
        .greenBlue
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .blue                      : return "blue"
        case .green                     : return "green"
        case .blueGreen                 : return "blueGreen"
        case .greenBlue                 : return "greenBlue"
        case let .unknown(value)    : return value
        }
    }
}
