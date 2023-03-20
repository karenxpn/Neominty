//
//  RecentTransfer.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
struct RecentTransfer: Identifiable, Codable {
    var id: String
    var name: String
    var image: String?
    var card: String
}
