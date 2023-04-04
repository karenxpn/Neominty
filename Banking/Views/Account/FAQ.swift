//
//  FAQ.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import SwiftUI

struct FAQ: View {
    
    @StateObject private var accountVM = AccountViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TextHelper(text: NSLocalizedString("youHaveQuestion", comment: ""),
                       color: AppColors.darkBlue,
                       fontName: Roboto.bold.rawValue,
                       fontSize: 24)
            
            // search bar
            HStack(spacing: 10) {
                Image("search")
                
                TextField(NSLocalizedString("search", comment: ""), text: $accountVM.search)
                    .font(.custom(Roboto.regular.rawValue, size: 16))
                    .padding(.vertical, 16)
            }.padding(.horizontal, 18)
                .background(AppColors.superLightGray)
                .cornerRadius(16)
            
            
            HStack {
                TextHelper(text: NSLocalizedString("frequentlyAsked", comment: ""),
                           fontName: Roboto.bold.rawValue,
                           fontSize: 20)
                Spacer()
                
                Button {
                    
                } label: {
                    TextHelper(text: NSLocalizedString("viewAll", comment: ""),
                               fontName: Roboto.bold.rawValue,
                               fontSize: 16)
                }
            }.padding(.top, 10)
            
            FAQList()
                .environmentObject(accountVM)
            
            
        }.padding(24)
            .task {
                accountVM.getFaqs()
            }
            .alert(NSLocalizedString("error", comment: ""), isPresented: $accountVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(accountVM.alertMessage)
            })
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("faq", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }
    }
}

struct FAQ_Previews: PreviewProvider {
    static var previews: some View {
        FAQ()
    }
}
