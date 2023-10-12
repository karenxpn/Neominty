//
//  Account.swift
//  Banking
//
//  Created by Karen Mirakyan on 31.03.23.
//

import SwiftUI
import StoreKit

struct Account: View {
    @AppStorage("userID") var userID: String = ""

    @Environment(\.requestReview) var requestReview
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
                                .environmentObject(accountVM)
                        }
                        
                    }.frame(height: 170)
                    
                    AccountListButton(icon: "account-info", label: NSLocalizedString("accountInfo", comment: "")) {
                        viewRouter.pushAccountPath(.info(name: accountVM.info?.name, flag: accountVM.info?.flag, phone: accountVM.info?.phone, email: accountVM.info?.email))
                    }.disabled(accountVM.info == nil)
                    
                    AccountListButton(icon: "settings", label: NSLocalizedString("generalSettings", comment: "")) {
                        viewRouter.pushAccountPath(.settings)

                    }
                    
                    AccountListButton(icon: "change-pin", label: NSLocalizedString("changePin", comment: "")) {
                        viewRouter.pushAccountPath(.changePin)
                    }
                    
                    Divider()
                    
                    AccountListButton(icon: "faq", label: NSLocalizedString("faq", comment: "")) {
                        viewRouter.pushAccountPath(.faq)
                    }
                    
                    AccountListButton(icon: "rate", label: NSLocalizedString("rateUs", comment: "")) {
                        requestReview()
                    }
                    
                }.padding(24)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            }.padding(.top, 1)
                .navigationTitle(Text(""))
                    .navigationBarTitleDisplayMode(.inline)
                    .alert(NSLocalizedString("error", comment: ""), isPresented: $accountVM.showAlert, actions: {
                        Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
                    }, message: {
                        Text(accountVM.alertMessage)
                    })
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            TextHelper(text: NSLocalizedString("account", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                        }
                    }.task {
                        if !userID.isEmpty {
                            accountVM.getAccountInfo()
                        }
                    }.navigationDestination(for: AccountViewPaths.self) { page in
                        viewRouter.buildAccountView(page: page)
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
