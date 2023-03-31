//
//  Account.swift
//  Banking
//
//  Created by Karen Mirakyan on 31.03.23.
//

import SwiftUI

struct Account: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        
        NavigationStack(path: $viewRouter.accountPath) {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 24) {
                    AccountListButton(icon: "account-info", label: NSLocalizedString("accountInfo", comment: "")) {
                        
                    }
                    
                    AccountListButton(icon: "settings", label: NSLocalizedString("generalSettings", comment: "")) {
                        
                    }
                    
                    AccountListButton(icon: "change-pin", label: NSLocalizedString("changePin", comment: "")) {
                        
                    }
                    
                    Divider()
                    
                    AccountListButton(icon: "faq", label: NSLocalizedString("faq", comment: "")) {
                        
                    }
                    
                    AccountListButton(icon: "rate", label: NSLocalizedString("rateUs", comment: "")) {
                        
                    }
                    
                }.padding(24)
            }.padding(.top, 1)
                .navigationTitle(Text(""))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            TextHelper(text: NSLocalizedString("account", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                        }
                    }
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
            .environmentObject(ViewRouter())
    }
}
