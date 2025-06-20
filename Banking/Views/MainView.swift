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
                    Tab(Tabs.home.label,
                        image: router.tab == .home ? "\(Tabs.home.icon).fill" : Tabs.home.icon,
                        value: Tabs.home) {
                        HomeView()
                    }
                    
                    Tab(Tabs.cards.label,
                        image: router.tab == .cards ? "\(Tabs.cards.icon).fill" : Tabs.cards.icon,
                        value: Tabs.cards) {
                        Cards()
                    }
                                        
                    Tab(Tabs.scan.label, image: Tabs.scan.icon, value: Tabs.scan, role: .search) {
                        QRView()
                    }
                    
                    Tab(Tabs.activity.label,
                        image: router.tab == .activity ?  "\(Tabs.activity.icon).fill" : Tabs.activity.icon,
                        value: Tabs.activity) {
                        Activity()
                    }
                                        
                    Tab(Tabs.profile.label,
                        image: router.tab == .profile ? "\(Tabs.profile.icon).fill" : Tabs.profile.icon,
                        value: Tabs.profile) {
                        Account()
                    }
                }.tint(Color(.tabSelection))
            } else {
                ZStack( alignment: .bottom) {
                    
                    VStack {
                        switch router.tab {
                        case .home:
                            HomeView()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        case .cards:
                            Cards()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        case .scan:
                            QRView()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        case .activity:
                            Activity()
                                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        case .profile:
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
