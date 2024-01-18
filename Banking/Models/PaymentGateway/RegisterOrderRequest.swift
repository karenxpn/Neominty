//
//  RegisterOrderRequest.swift
//  Banking
//
//  Created by Karen Mirakyan on 25.04.23.
//

import Foundation
struct RegisterOrderRequest: Codable {
    var userName: String
    var password: String
    var orderNumber: String
    var amount: Decimal
    var returnUrl: String
    var pageView: String?
    var clientId: String?
}
