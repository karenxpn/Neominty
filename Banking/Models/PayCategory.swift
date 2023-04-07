//
//  PayCategory.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
struct PayCategory: Identifiable, Codable {
    var id: String
    var title: String
    var subCategory: [SubCategory]
}

struct SubCategory: Identifiable, Codable {
    var id: String
    var image: String
    var name: String
    var address: String
}


struct PayCategoryViewModel: Identifiable {
    var model: PayCategory
    init(model: PayCategory)  {
        self.model = model
    }
    
    var id: String      { self.model.id }
    var title: String   { self.model.title }
    var image: String   { self.model.title.lowercased() + "-icon" }
    var subCategories: [SubCategory]    { self.model.subCategory }
}
