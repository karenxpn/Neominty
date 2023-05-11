//
//  FAQModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import Foundation

struct FAQListModel: Codable {
    var hits: [FAQModel]
}

struct FAQModel: Identifiable, Codable {
    var id: String
    var question: String
    var answer: String
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case question
        case answer
    }
}
