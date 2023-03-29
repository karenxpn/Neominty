//
//  CardBankType.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation

public enum CreditCardType: String {
    case amex = "^3[47][0-9]{5,}$"
    case visa = "^4[0-9]{6,}$"
    case masterCard = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
    case maestro = "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
//    case dinersClub = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
//    case jcb = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
//    case discover = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
//    case unionPay = "^62[0-5]\\d{13,16}$"
    case mir = "^2[0-9]{6,}$"
    case nonIdentified
    
    /// Possible C/C number lengths for each C/C type
    /// reference: https://en.wikipedia.org/wiki/Payment_card_number
//    var validNumberLength: IndexSet {
//        switch self {
//        case .visa:
//            return IndexSet([13,16])
//        case .amex:
//            return IndexSet(integer: 15)
//        case .maestro:
//            return IndexSet(integersIn: 12...19)
//        case .dinersClub:
//            return IndexSet(integersIn: 14...19)
//        case .jcb, .discover, .unionPay, .mir:
//            return IndexSet(integersIn: 16...19)
//        default:
//            return IndexSet(integer: 16)
//        }
//    }
    
    public var textFieldIcon: String {
        switch self {
        case .visa:
            return "visa"
        case .masterCard:
            return "mc_symbol"
        case .maestro:
            return "maestro"
        case .mir:
            return "mir"
        default:
            return "card-placeholder"
        }
    }
}

public struct CreditCardValidator {
    
    /// Available credit card types
    private let types: [CreditCardType] = [
        .amex,
        .visa,
        .masterCard,
        .maestro,
        .mir
    ]
    
    private let string: String
    
    /// Create validation value
    /// - Parameter string: credit card number
    public init(_ string: String) {
        self.string = string.numbers
    }
    
    /// Get card type
    /// Card number validation is not perfroms here
    public var type: CreditCardType? {
        types.first { type in
            NSPredicate(format: "SELF MATCHES %@", type.rawValue)
                .evaluate(
                    with: string.numbers
                )
        }
    }
}

fileprivate extension String {
 
    var numbers: String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
}
