//
//  PayCategoryCell.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import SwiftUI

struct PayCategoryCell: View {
    let category: PayCategoryViewModel
    
    var body: some View {
        Button {
            
        } label: {
            LazyVStack(alignment: .leading, spacing: 8) {
                Image(category.image)
                    .foregroundColor(.black)
                TextHelper(text: category.title, color: AppColors.darkBlue, fontName: Roboto.medium.rawValue, fontSize: 14)
            }.padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppColors.lightGray, lineWidth: 1)
                        .background {
//                            if selected?.id == category.id {
//                                RoundedRectangle(cornerRadius: 16)
//                                    .fill(AppColors.superLightGray)
//                            }
                        }
                }.cornerRadius(16)
        }
    }
}

struct PayCategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        PayCategoryCell(category: PayCategoryViewModel(model: PreviewModels.payCategories[0]))
    }
}
