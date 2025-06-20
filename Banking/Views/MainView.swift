//
//  MainView.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: Router
    @StateObject private var notificationVM = PushNotificationViewModel()
    @AppStorage("userID") var userID: String = ""
    
    
    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                TabView(selection: $router.tab) {
                    Tab(NSLocalizedString("home", comment: ""),
                        image: router.tab == 0 ? "home_icon.fill" : "home_icon",
                        value: 0) {
                        HomeView()
                    }
                    
                    Tab(NSLocalizedString("myCard", comment: ""),
                        image: router.tab == 1 ? "card_icon.fill" : "card_icon",
                        value: 1) {
                        Cards()
                    }
                                        
                    Tab("", image: "scan_icon", value: 2, role: .search) {
                        QRView()
                    }
                    
                    Tab(NSLocalizedString("activity", comment: ""),
                        image: router.tab == 3 ?  "activity_icon.fill" : "activity_icon",
                        value: 3) {
                        Activity()
                    }
                                        
                    Tab(NSLocalizedString("profile", comment: ""),
                        image: router.tab == 4 ? "profile_icon.fill" : "profile_icon",
                        value: 4) {
                        Account()
                    }
                }.tint(Color(.tabSelection))
            } else {
                ZStack( alignment: .bottom) {
                    
                    VStack {
                        
                        if router.tab == 0 {
                            HomeView()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        } else if router.tab == 1 {
                            Cards()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        } else if router.tab == 2{
                            QRView()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        } else if router.tab == 3{
                            Activity()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            
                        } else if router.tab == 4 {
                            Account()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                    }
                    
                    CustomTabView()
                    
                }.edgesIgnoringSafeArea(.bottom)
            }
        }.task({
            await notificationVM.requestPermission()
            await notificationVM.checkPermission()
        }).environmentObject(router)
        .onOpenURL { url in
            print(url)
            router.handleDeeplink(from: url)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
