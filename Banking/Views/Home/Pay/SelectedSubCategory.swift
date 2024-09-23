//
//  SelectedSubCategory.swift
//  Banking
//
//  Created by Karen Mirakyan on 18.10.23.
//

import SwiftUI

struct SelectedSubCategory: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var payVM: PayViewModel
    let subCategory: SubCategory
    @State private var fields = [String: String]()
    @State private var fieldsValidation = [String: Bool]()
    @Binding var navigate: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                ImageHelper(image: subCategory.image, contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.25)
                    .clipped()


                TextHelper(text: subCategory.name, colorResource: .darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                TextHelper(text: subCategory.address, colorResource: .appGray, fontName: Roboto.regular.rawValue, fontSize: 12)

                ForEach(subCategory.fields, id: \.id) { field in
                    SubCategoryTextField(field: field, fields: $fields, validation: $fieldsValidation)
                }

                ButtonHelper(disabled: fieldsValidation.values.contains(false)
                             || subCategory.fields.map({fieldsValidation[$0.name] == nil}).contains(true), label: NSLocalizedString("continue", comment: "")) {
                    
                    payVM.selectedPaymentCategory = subCategory
                    payVM.fields = fields
                    navigate.toggle()
                    dismiss()
                    
                }.padding(.top, 100)

            }.padding(24)
        }.scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    SelectedSubCategory(subCategory: PreviewModels.payCategories[0].subCategories[0], navigate: .constant(false))
}
