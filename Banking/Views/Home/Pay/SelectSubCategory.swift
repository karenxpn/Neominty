//
//  SelectSubCategory.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import SwiftUI

struct SelectSubCategory: View {
    @EnvironmentObject private var payVM: PayViewModel
    let category: PayCategoryViewModel
    @Binding var navigateToDetails: Bool
    @State private var selectedCategory: String = ""
    @State private var fields = [String: String]()
    @State private var fieldsValidation = [String: Bool]()

    
    init(category: PayCategoryViewModel, navigateToDetails: Binding<Bool>) {
        self.category = category
        _selectedCategory = State(initialValue: category.subCategories[0].id)
        _navigateToDetails = navigateToDetails
        
        
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
                    }.padding(.top, -50)
                }.frame(height: UIScreen.main.bounds.height * 0.25)
                    .tabViewStyle(.page)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                
                
                if let subCategory = category.subCategories.first(where: { $0.id == selectedCategory }) {
                    TextHelper(text: subCategory.name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    TextHelper(text: subCategory.address, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                    
                    ForEach(subCategory.fields, id: \.id) { field in
                        SubCategoryTextField(field: field, fields: $fields, validation: $fieldsValidation)
                    }
                    
                    ButtonHelper(disabled: fieldsValidation.values.contains(false)
                                 || subCategory.fields.map({fieldsValidation[$0.name] == nil}).contains(true), label: NSLocalizedString("continue", comment: "")) {
                        payVM.selectedPaymentCategory = category.subCategories.first(where: {$0.id == selectedCategory})
                        print(fields)
                        navigateToDetails.toggle()
                        // navigation
                    }.padding(.top, 100)
                }
                
            }.padding(24)
        }.scrollDismissesKeyboard(.immediately)
        
    }
}

struct SelectSubCategory_Previews: PreviewProvider {
    static var previews: some View {
        SelectSubCategory(category: PayCategoryViewModel(model: PreviewModels.payCategories[0]), navigateToDetails: .constant(false))
            .environmentObject(PayViewModel())
    }
}
