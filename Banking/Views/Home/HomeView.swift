//
//  HomeView.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        NavigationStack(path: $viewRouter.homePath) {
            
            ScrollView(showsIndicators: false) {
                HomeMenu()
                    .environmentObject(viewRouter)
                
                Button {
                    viewRouter.pushHomePath(.allTransactions)
                } label: {
                    Text( "navigate to all transactions")
                        .padding(.all, 20)
                }
            }.navigationTitle(Text(""))
            .navigationDestination(for: HomeViewPaths.self) { page in
                switch page {
                case .allTransactions:
                    AllTransactions()
                case .home:
                    HomeView()
                case .send:
                    MoneyTransfer()
                case .exchange:
                    Exchange()
                case .receive:
                    RequestTransfer()
                case .more:
                    MoreTransfers()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewRouter())
    }
}
