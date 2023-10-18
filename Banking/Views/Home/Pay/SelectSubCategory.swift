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
    @State private var selectedCategory: SubCategory?
    @State private var navigate: Bool = false
    
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
                                self.selectedCategory = sub
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
                .sheet(item: $selectedCategory, content: { item in
                    SelectedSubCategory(subCategory: item, navigate: $navigate)
                })
            
        }.scrollDismissesKeyboard(.immediately)
            .navigationTitle(Text(""))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: category.title, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }.navigationDestination(isPresented: $navigate) {
                PaymentDetails()
                    .environmentObject(payVM)
            }
    }
}

struct SelectSubCategory_Previews: PreviewProvider {
    static var previews: some View {
        SelectSubCategory(category: PayCategoryViewModel(model: PreviewModels.payCategories[0]))
            .environmentObject(PayViewModel())
    }
}
