//
//  RecentTransfer.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
import SwiftUI


struct RecentTransfer: Identifiable, Codable, Equatable, Hashable {
    var id: String
    var name: String
    var image: String?
    var card: String

    static let hexColors: [String] = [
        "#1DAB87", "#1D3A70", "#6B7280", "#1D2734",
        "#59E3A7", "#FB923C", "#000000", "#004D40"
    ]

    var color: Color

    init(id: String, name: String, image: String? = nil, card: String) {
        self.id = id
        self.name = name
        self.image = image
        self.card = card
        self.color = Color(hex: RecentTransfer.hexColors.randomElement() ?? "#000000")!
    }

    // MARK: - Codable Compliance
    enum CodingKeys: String, CodingKey {
        case id, name, image, card, colorHex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        card = try container.decode(String.self, forKey: .card)

        let colorHex = try container.decode(String.self, forKey: .colorHex)
        self.color = Color(hex: colorHex) ?? .black
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encode(card, forKey: .card)
        try container.encode(color.toHex(), forKey: .colorHex)
    }
}
