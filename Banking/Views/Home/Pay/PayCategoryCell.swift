//
//  PayCategoryCell.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import SwiftUI

struct PayCategoryCell: View {
    @EnvironmentObject var payVM: PayViewModel
    let category: PayCategoryViewModel
    @State private var showCategory: Bool = false
    
    var body: some View {
        Button {
            showCategory.toggle()
        } label: {
            LazyVStack(alignment: .leading, spacing: 8) {
                Image(category.image)
                    .foregroundColor(.black)
                TextHelper(text: category.title, color: AppColors.darkBlue, fontName: Roboto.medium.rawValue, fontSize: 14)
            }.padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppColors.lightGray, lineWidth: 1)
                }.cornerRadius(16)
        }.navigationDestination(isPresented: $showCategory, destination: {
            SelectSubCategory(category: category)
                .environmentObject(payVM)
        })
    }
}

struct PayCategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        PayCategoryCell(category: PayCategoryViewModel(model: PreviewModels.payCategories[0]))
    }
}
