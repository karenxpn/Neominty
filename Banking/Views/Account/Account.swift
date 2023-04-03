//
//  Account.swift
//  Banking
//
//  Created by Karen Mirakyan on 31.03.23.
//

import SwiftUI

struct Account: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var accountVM = AccountViewModel()
    
    var body: some View {
        
        NavigationStack(path: $viewRouter.accountPath) {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 24) {
                    
                    VStack {
                        
                        if accountVM.loading {
                            ProgressView()
                        } else if accountVM.info != nil {
                            AccountViewPersonalInfo(info: accountVM.info!)
                        }
                        
                    }.frame(height: 170)
                    
                    AccountListButton(icon: "account-info", label: NSLocalizedString("accountInfo", comment: "")) {
                        viewRouter.pushAccountPath(.info)
                    }
                    
                    AccountListButton(icon: "settings", label: NSLocalizedString("generalSettings", comment: "")) {
                        viewRouter.pushAccountPath(.settings)

                    }
                    
                    AccountListButton(icon: "change-pin", label: NSLocalizedString("changePin", comment: "")) {
                        viewRouter.pushAccountPath(.changePin)
                    }
                    
                    Divider()
                    
                    AccountListButton(icon: "faq", label: NSLocalizedString("faq", comment: "")) {
                        
                    }
                    
                    AccountListButton(icon: "rate", label: NSLocalizedString("rateUs", comment: "")) {
                        
                    }
                    
                }.padding(24)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            }.padding(.top, 1)
                .navigationTitle(Text(""))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            TextHelper(text: NSLocalizedString("account", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                        }
                    }.task {
                        accountVM.getAccountInfo()
                    }.navigationDestination(for: AccountViewPaths.self) { value in
                        if value == .settings {
                            GeneralSettings()
                        } else if value == .changePin {
                            CheckPin()
                        } else if value == .info {
                            AccountInfo(name: accountVM.info?.name,
                                        flag: accountVM.info?.flag,
                                        phone: accountVM.info?.phone,
                                        email: accountVM.info?.email)
                        } else {
                            ViewInDevelopmentMode()
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
