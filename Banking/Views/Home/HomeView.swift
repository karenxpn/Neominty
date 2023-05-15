//
//  HomeView.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI
import CollectionViewPagingLayout

struct HomeView: View {
    @AppStorage("fullName") var localName: String = ""
    
    @EnvironmentObject private var viewRouter: ViewRouter
    @StateObject private var homeVM = HomeViewModel()
    @StateObject var transferVM = TransferViewModel()
    
    var options: ScaleTransformViewOptions {
    
        var viewOptions = ScaleTransformViewOptions.layout(.easeIn)
        viewOptions.shadowEnabled = false
        return viewOptions
    }
    
    var body: some View {
        NavigationStack(path: $viewRouter.homePath) {
            
            ScrollView(showsIndicators: false) {
                
                ZStack(alignment: .bottom) {

                    Image("layer-blur")
                        .opacity(0.9)

                    VStack {

                        if homeVM.loading {
                            ProgressView()
                        } else {
                            ScalePageView(homeVM.cards) { card in
                                UserCard(card: card, selected: card.defaultCard)
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                            }.options(options)
                                .pagePadding(
                                    vertical: .absolute(40),
                                    horizontal: .absolute(50)
                                )
                                .frame(height: 250)
                        }

                        HomeMenu()
                            .environmentObject(viewRouter)

                    }
                }
                
                RecentTransactions(loading: $homeVM.loadingTransactions, transactions: homeVM.transactions) {
                    viewRouter.pushHomePath(.allTransactions)
                }
            }.padding(.top, 1)
                .task {
                    homeVM.getCards()
                    homeVM.getRecentTransfers()
                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .alert(NSLocalizedString("error", comment: ""), isPresented: $homeVM.showAlert, actions: {
                    Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
                }, message: {
                    Text(homeVM.alertMessage)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        VStack(alignment: .leading, spacing: 4) {
                            TextHelper(text: localName.isEmpty ? NSLocalizedString("welcomeToNeominty", comment: "") : NSLocalizedString("welcomeBack", comment: ""), color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                            
                            TextHelper(text: localName, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewRouter.pushHomePath(.notifications)
                        } label: {
                            Image(homeVM.hasUnreadNotification ? "notification-unread" : "notification")
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
    @StateObject var homeVM = HomeViewModel()
    static var previews: some View {
        
        HomeView()
            .environmentObject(ViewRouter())
    }
}
