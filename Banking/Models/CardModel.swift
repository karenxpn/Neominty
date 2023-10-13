//
//  CardModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct CardModel: Identifiable, Codable, Equatable, Hashable {

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

enum CardCurrency: RawRepresentable, CaseIterable, Codable, Hashable {
    
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

enum CardType : RawRepresentable, CaseIterable, Codable, Hashable {
    
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


enum CardDesign : RawRepresentable, CaseIterable, Codable, Identifiable, Hashable {
    
    typealias RawValue = String
    
    case standard
    case hex
    case signed
    case standardBlue
    case standardGreen
    case standardBlueGreen
    case standardGreenBlue
    case hexBlue
    case hexGreen
    case hexBlueGreen
    case hexGreenBlue
    case blue
    case green
    case blueGreen
    case greenBlue
    case signedGreenBlue
    case signedBlueGreen
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .standard,
        .hex,
        .signed,
        .blue,
        .green,
        .blueGreen,
        .greenBlue,
        .standardBlue,
        .standardGreen,
        .standardBlueGreen,
        .standardGreenBlue,
        .hexBlue,
        .hexGreen,
        .hexBlueGreen,
        .hexGreenBlue,
        .signedGreenBlue,
        .signedBlueGreen
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
        case .standardBlue              : return "standardBlue"
        case .standardGreen             : return "standardGreen"
        case .standardBlueGreen         : return "standardBlueGreen"
        case .standardGreenBlue         : return "standardGreenBlue"
        case .hexBlue                   : return "hexBlue"
        case .hexGreen                  : return "hexGreen"
        case .hexGreenBlue              : return "hexGreenBlue"
        case .hexBlueGreen              : return "hexBlueGreen"
        case .signedGreenBlue           : return "signedGreenBlue"
        case .signedBlueGreen           : return "signedBlueGreen"
        case .standard                  : return "standard"
        case .signed                    : return "signed"
        case .hex                       : return "hex"
        case let .unknown(value)    : return value
        }
    }
}
