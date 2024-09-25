//
//  PayCategory.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
import FirebaseFirestore

struct PayCategory: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var subCategories: [SubCategory]
}

struct SubCategory: Identifiable, Codable {
    var id: String
    var image: String
    var name: String
    var address: String
    var fields: [SubcategoryField]
}


struct PayCategoryViewModel: Identifiable {
    var model: PayCategory
    init(model: PayCategory)  {
        self.model = model
    }
    
    var id: String      { self.model.id ?? UUID().uuidString }
    var title: String   { NSLocalizedString("\(self.model.title.lowercased())", comment: "")}
    var image: String   { self.model.title.lowercased() + "-icon" }
    var subCategories: [SubCategory]    { self.model.subCategories }
}

struct SubcategoryField: Identifiable, Codable {
    var id: String
    var placeholder: String
    var regex: String
    var name: String
    var keyboardType: FieldKeyboardType
}
