//
//  PayCategoryCell.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import SwiftUI

struct PayCategoryCell: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var payVM: PayViewModel
    let category: PayCategoryViewModel
    @State private var showCategory: Bool = false
    
    var body: some View {
        Button {
            router.pushHomePath(.selectPaySubcategory(category: category, vm: payVM))
        } label: {
            LazyVStack(alignment: .leading, spacing: 13) {
                Image(category.image)
                    .foregroundColor(.black)
                TextHelper(text: category.title, colorResource: .darkBlueText, fontName: .medium, fontSize: 14)
            }.padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(.lightGray), lineWidth: 1)
                }.cornerRadius(16)
        }
    }
}

struct PayCategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        PayCategoryCell(category: PayCategoryViewModel(model: PreviewModels.payCategories[0]))
    }
}
