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
                
                ZStack(alignment: .bottom) {
                    
                    Image("layer-blur")
                        .opacity(0.9)

                    HomeMenu()
                        .environmentObject(viewRouter)
                }
                
                Button {
                    viewRouter.pushHomePath(.allTransactions)
                } label: {
                    Text( "navigate to all transactions")
                        .padding(.all, 20)
                }
            }.padding(.top, 1)
            .navigationTitle(Text(""))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        VStack(alignment: .leading, spacing: 4) {
                            TextHelper(text: NSLocalizedString("welcomeBack", comment: ""), color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                            
                            TextHelper(text: "Tonny Monthana", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewRouter.pushHomePath(.notifications)
                        } label: {
                            Image("notification")
                        }

                    }
                }
            .navigationDestination(for: HomeViewPaths.self) { page in
                switch page {
                case .allTransactions:
                    AllTransactions()
                case .send:
                    MoneyTransfer()
                case .exchange:
                    Exchange()
                case .receive:
                    RequestTransfer()
                case .more:
                    MoreTransfers()
                case .notifications:
                    Notifications()
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
