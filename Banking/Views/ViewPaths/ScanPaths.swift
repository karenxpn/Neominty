//
//  ScanPaths.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.25.
//

import Foundation
enum ScanViewPaths: Equatable, Hashable {
    case attachCard
    case transferSuccess(amount: String, currency: CardCurrency, action: CustomAction)
}
