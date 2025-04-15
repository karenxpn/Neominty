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
            .task({
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
