//
//  BindingToCardPaymentRequestModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 13.12.23.
//

import Foundation
struct BindingToCardPaymentRequestModel: Encodable {
    var sender: String
    var receiver: String
    var amount: Decimal
    var currency: String
}
