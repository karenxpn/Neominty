//
//  OrderStatusResponse.swift
//  Banking
//
//  Created by Karen Mirakyan on 25.04.23.
//

import Foundation
struct OrderStatusResponse: Codable {
    var orderNumber: String
    var orderStatus: Int?
    var actionCode: Int
    var actionCodeDescription: String
    var errorCode: String?
    var errorMessage: String?
    var amount: Decimal
    var currency: String?
    var cardAuthInfo: CardAuthInfo?
    var bindingInfo: BindingInfo?
    var bankInfo: BankInfo?
}

struct CardAuthInfo: Codable {
    var pan: String?
    var expiration: String?
    var cardholderName: String?
    var approvalCode: String?
}


struct BindingInfo: Codable {
    var clientId: String?
    var bindingId: String?
}

struct BankInfo: Codable {
    var bankName: String
}
