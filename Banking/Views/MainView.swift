//
//  MainView.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewRouter = ViewRouter()
    @StateObject private var notificationVM = PushNotificationViewModel()
    @AppStorage("userID") var userID: String = ""

    
    var body: some View {
        ZStack( alignment: .bottom) {
            
            VStack {
                
                if viewRouter.tab == 0 {
                    HomeView()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if viewRouter.tab == 1 {
                    Cards()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if viewRouter.tab == 2{
                    QRView()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if viewRouter.tab == 3{
                    Activity()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                } else if viewRouter.tab == 4 {
                    Account()
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
            }
            
            CustomTabView()
            
        }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                notificationVM.requestPermission()
                viewRouter.getAccountInfo()
            }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                // send request for offline
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                // send request for online
            }.environmentObject(viewRouter)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
