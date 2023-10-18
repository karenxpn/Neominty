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
    @State private var selectedCategory: String = ""
    @State private var fields = [String: String]()
    @State private var fieldsValidation = [String: Bool]()
    @State private var navigate: Bool = false


    
    init(category: PayCategoryViewModel) {
        self.category = category
        _selectedCategory = State(initialValue: category.subCategories[0].id)    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
            
            LazyVGrid(columns: columns, spacing: 20, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(category.subCategories.filter{
                        payVM.search.isEmpty
                        ? true
                        : ($0.name.localizedCaseInsensitiveContains(self.payVM.search))}, id: \.id) { sub in
                            
                            Button {
                                
                            } label: {
                                LazyVStack(alignment: .leading, spacing: 8) {
                                    ImageHelper(image: sub.image, contentMode: .fit)
                                        .frame(height: 100)
                                        .clipped()
                                    
                                    TextHelper(text: sub.name, color: AppColors.darkBlue, fontName: Roboto.medium.rawValue, fontSize: 14)

                                }.padding(16)
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(AppColors.lightGray, lineWidth: 1)
                                    }.cornerRadius(16)
                            }
                    }
                } header: {
                    HStack(spacing: 10) {
                        Image("search")
                        
                        TextField(NSLocalizedString("search", comment: ""), text: $payVM.search)
                            .font(.custom(Roboto.regular.rawValue, size: 16))
                            .padding(.vertical, 16)
                    }.padding(.horizontal, 18)
                        .background(AppColors.superLightGray)
                        .cornerRadius(16)
                        .padding(.top, 16)
                }
            }.padding([.horizontal, .bottom], 24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)

//            VStack(alignment: .leading, spacing: 10) {
//                TabView(selection: $selectedCategory) {
//                    ForEach(category.subCategories, id: \.id) { subCategory in
//                        ImageHelper(image: subCategory.image, contentMode: .fit)
//                            .frame(width: UIScreen.main.bounds.width * 0.8,
//                                   height: UIScreen.main.bounds.height * 0.25)
//                            .clipped()
//                    }.padding(.top, -50)
//                }.frame(height: UIScreen.main.bounds.height * 0.25)
//                    .tabViewStyle(.page)
//                    .tabViewStyle(.page(indexDisplayMode: .always))
//                
//                
//                if let subCategory = category.subCategories.first(where: { $0.id == selectedCategory }) {
//                    TextHelper(text: subCategory.name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
//                    TextHelper(text: subCategory.address, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
//                    
//                    ForEach(subCategory.fields, id: \.id) { field in
//                        SubCategoryTextField(field: field, fields: $fields, validation: $fieldsValidation)
//                    }
//                    
//                    ButtonHelper(disabled: fieldsValidation.values.contains(false)
//                                 || subCategory.fields.map({fieldsValidation[$0.name] == nil}).contains(true), label: NSLocalizedString("continue", comment: "")) {
//                        payVM.selectedPaymentCategory = category.subCategories.first(where: {$0.id == selectedCategory})
//                        payVM.fields = fields
//                        showSheet.toggle()
//                        navigateToDetails.toggle()
//                        // navigation
//                    }.padding(.top, 100)
//                }
//                
//            }.padding(24)
        }.scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: category.title, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }
    }
}

struct SelectSubCategory_Previews: PreviewProvider {
    static var previews: some View {
        SelectSubCategory(category: PayCategoryViewModel(model: PreviewModels.payCategories[0]))
            .environmentObject(PayViewModel())
    }
}
