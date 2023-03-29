//
//  CardBankType.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation

public enum CardBankType {
    case visa
    case mastercard
    case maestro
    case mir
    case nonIdentified
    
    public var textFieldIcon: String {
        switch self {
        case .visa:
            return "visa"
        case .mastercard:
            return "mc_symbol"
        case .maestro:
            return "maestro"
        case .mir:
            return "mir"
        case .nonIdentified:
            return "card-placeholder"
        }
    }
    
    var regex: String {
        switch self {
            
        case .visa:
            return "^4[0-9]{6,}$"
        case .mastercard:
            return "^5[1-5][0-9]{5,}$"
        case .maestro:
            return "^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\\d+$"
        case .mir:
            return "^220[0-4]\\d+$"
        case .nonIdentified:
            return ""
        }
    }
}
