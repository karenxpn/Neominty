//
//  OrderStatusRequest.swift
//  Banking
//
//  Created by Karen Mirakyan on 25.04.23.
//

import Foundation
struct OrderStatusRequest: Codable {
    var userName: String
    var password: String
    var orderId: String
    var orderNumber: String
}
