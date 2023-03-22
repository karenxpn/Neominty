//
//  MainView.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewRouter = ViewRouter()
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var transferVM = TransferViewModel()
    
    var body: some View {
        ZStack( alignment: .bottom) {
            
            VStack {
                
                if viewRouter.tab == 0 {
                    HomeView()
                        .environmentObject(homeVM)
                        .environmentObject(transferVM)
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                } else if viewRouter.tab == 1 {
                    Text("my cart")
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                } else if viewRouter.tab == 2{
                    Text("scan")
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                    
                } else if viewRouter.tab == 3{
                    Text("activity")
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                } else if viewRouter.tab == 4 {
                    Text("profile")
                        .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                }
            }
            
            CustomTabView()
            
        }.edgesIgnoringSafeArea(.bottom)
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
