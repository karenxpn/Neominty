//
//  CardModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct CardModel: Identifiable, Codable {
    @DocumentID var id: String?
    var cardPan: String
    var cardHolder: String
    var expirationDate: String
    var currency: CardCurrency = .usd
    var bankName: String
    var defaultCard: Bool = true
    var cardStyle: CardDesign
    var cardType: CardType
    var createdAt: Timestamp
    var bindingId: String
}

enum CardCurrency: RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case usd
    case amd
    case rub
    case eur
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .usd,
        .amd,
        .rub,
        .eur
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .usd   : return "USD"
        case .amd   : return "AMD"
        case .rub   : return "RUB"
        case .eur   : return "EUR"
            
        case let .unknown(value)    : return value
        }
    }
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
        case .masterCard            : return "Mastercard"
        case .visa                  : return "Visa"
        case .arca                  : return "ARCA"
        case .amex                  : return "American Express"
        case .maestro               : return "Maestro"
        case .unionPay              : return "UnionPay"
        case .mir                   : return "Mir"
            
            
        case let .unknown(value)    : return value
        }
    }
    
    public var icon: String {
        switch self {
        case .visa:
            return "visa"
        case .masterCard:
            return "mc_symbol"
        case .maestro:
            return "maestro"
        case .mir:
            return "mir"
        case .amex:
            return "amex"
        default:
            return ""
        }
    }
}


enum CardDesign : RawRepresentable, CaseIterable, Codable, Identifiable {
    
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
    
    var id: String {
        self.rawValue
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
