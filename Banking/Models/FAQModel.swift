//
//  FAQModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import Foundation
import FirebaseFirestore

struct FAQModel: Identifiable, Codable {
    @DocumentID var id: String?
    var question: String
    var answer: String
}
