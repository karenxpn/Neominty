//
//  BindingToBindingPaymentRequestModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 13.12.23.
//

import Foundation
struct BindingToBindingPaymentRequestModel: Encodable {
    var sender: String
    var receiver: String
    var amount: Decimal
    var currency: String
}
