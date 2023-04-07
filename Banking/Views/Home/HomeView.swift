//
//  HomeView.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @StateObject private var homeVM = HomeViewModel()
    @StateObject var transferVM = TransferViewModel()
    
    var body: some View {
        NavigationStack(path: $viewRouter.homePath) {
            
            ScrollView(showsIndicators: false) {
                
                ZStack(alignment: .bottom) {
                    
                    Image("layer-blur")
                        .opacity(0.9)
                    
                    VStack(spacing: 34) {
                        
                        ScrollView( .horizontal, showsIndicators: false ) {
                            LazyHStack(spacing: 16) {
                                ForEach( homeVM.cards, id: \.id ) { card in
                                    UserCard(card: card, selected: card.defaultCard)
                                        .frame(width: UIScreen.main.bounds.width * 0.8)
                                }
                            }.padding(.horizontal, 20)
                        }
                        
                        
                        HomeMenu()
                            .environmentObject(viewRouter)
                        
                    }.padding(.top)
                }
                
                
                RecentTransactions(transactions: homeVM.transactions) {
                    viewRouter.pushHomePath(.allTransactions)

                }
            }.padding(.top, 1)
                .navigationBarTitle(Text(""), displayMode: .inline)
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
                        MoneyTransfer(cards: homeVM.cards)
                    case .pay:
                        PayView()
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
