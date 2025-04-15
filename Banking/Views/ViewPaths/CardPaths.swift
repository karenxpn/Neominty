//
//  CardPaths.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.25.
//

import Foundation

enum MyCardViewPaths: Equatable, Hashable {
    case selectNewCardStyle
    case attachCard(style: CardDesign)
}
