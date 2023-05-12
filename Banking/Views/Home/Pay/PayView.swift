//
//  PayView.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import SwiftUI

struct PayView: View {
    @StateObject private var payVM = PayViewModel()
    @State private var navigate: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                TextHelper(text: NSLocalizedString("everythingYouNeed", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                TextHelper(text: NSLocalizedString("everythingYouNeedMessage", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 16)
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding([.horizontal, .top], 24)
            
            if payVM.loading {
                ProgressView()
            } else {
                let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
                
                LazyVGrid(columns: columns, spacing: 20, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(payVM.categories.filter{
                            payVM.search.isEmpty
                            ? true
                            : ($0.title.localizedCaseInsensitiveContains(self.payVM.search)
                            || $0.subCategories.contains(where: { $0.name.localizedCaseInsensitiveContains(self.payVM.search)}))}, id: \.id) { category in
                            PayCategoryCell(category: category, navigateToDetails: $navigate)
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
            }
            
        }.padding(.top, 1)
            .alert(NSLocalizedString("error", comment: ""), isPresented: $payVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(payVM.alertMessage)
            })
            .scrollDismissesKeyboard(.immediately)
            .navigationDestination(isPresented: $navigate) {
                PaymentDetails()
                    .environmentObject(payVM)
            }
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("pay", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }.task {
                payVM.getCategories()
            }.environmentObject(payVM)
    }
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView()
    }
}
