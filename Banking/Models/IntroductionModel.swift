//
//  IntroductionModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import FirebaseFirestore

struct IntroductionModel: Codable, Identifiable {
    @DocumentID var id: String?
    var image: String
    var title: String
    var body: String
}
