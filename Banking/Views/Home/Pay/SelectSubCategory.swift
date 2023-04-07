//
//  SelectSubCategory.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import SwiftUI

struct SelectSubCategory: View {
    @StateObject private var payVM = PayViewModel()
    let category: PayCategoryViewModel
    @State private var selectedCategory: String = ""
    
    init(category: PayCategoryViewModel) {
        self.category = category
        _selectedCategory = State(initialValue: category.subCategories[0].id)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(AppColors.darkBlue)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(AppColors.lightGray)
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                TabView(selection: $selectedCategory) {
                    ForEach(category.subCategories, id: \.id) { subCategory in
                        Image(subCategory.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.8,
                                   height: UIScreen.main.bounds.height * 0.25)
                            .clipped()
//                            .cornerRadius(30)
                    }.padding(.top, -50)
                }.frame(height: UIScreen.main.bounds.height * 0.25)
                    .tabViewStyle(.page)
                    .tabViewStyle(.page(indexDisplayMode: .always))
//                    .onChange(of: activityVM.selectedCard) { newValue in
//                        activityVM.getActivity()
//                    }
                
                
                if let subCategory = category.subCategories.first(where: { $0.id == selectedCategory }) {
                    TextHelper(text: subCategory.name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    TextHelper(text: subCategory.address, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)

                    HStack(spacing: 10) {
                        Image("search")
                        
                        TextField(NSLocalizedString("accountNumber", comment: ""), text: $payVM.accountNumber)
                            .font(.custom(Roboto.regular.rawValue, size: 16))
                            .padding(.vertical, 16)
                    }.padding(.horizontal, 18)
                        .background(AppColors.superLightGray)
                        .cornerRadius(16)
                        .padding(.top, 16)
                    
                    ButtonHelper(disabled: payVM.accountNumber.isEmpty, label: NSLocalizedString("continue", comment: "")) {
                        
                    }.padding(.top, 100)
                }
                
            }.padding(24)
        }

    }
}

struct SelectSubCategory_Previews: PreviewProvider {
    static var previews: some View {
        SelectSubCategory(category: PayCategoryViewModel(model: PreviewModels.payCategories[0]))
    }
}
