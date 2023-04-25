//
//  RegisterOrderResponse.swift
//  Banking
//
//  Created by Karen Mirakyan on 25.04.23.
//

import Foundation
struct RegisterOrderResponse: Codable {
    var orderId: String?
    var formUrl: String?
    var errorCode: Int?
    var errorCodeString: String?
    var error: Bool?
    var errorMessage: String?
}
