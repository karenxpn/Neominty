//
//  HomeView.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI
import Shimmer
import FirebaseAuth
import ACarousel


struct HomeView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @StateObject private var homeVM = HomeViewModel()
    @StateObject var transferVM = TransferViewModel()
    @State private var showCardAttachedAlert: Bool = false
    @State private var cardIndex = 0
    

    
    var body: some View {
        NavigationStack(path: $viewRouter.homePath) {
            
            ScrollView(showsIndicators: false) {
                
                ZStack(alignment: .bottom) {
                    
                    Image("layer-blur")
                        .opacity(0.9)
                    
                    VStack {
                        
                        if homeVM.loading {
                            UserCard(card: PreviewModels.visaCard, selected: false)
                                .redacted(reason: .placeholder)
                                .shimmering(
                                    active: homeVM.loading,
                                    animation: .easeInOut(duration: 1)
                                        .repeatForever(autoreverses: false)
                                )
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: 250)
                        } else if homeVM.cards.isEmpty && !homeVM.alertMessage.isEmpty {
                            ViewFailedToLoad {
                                homeVM.getCards()
                                homeVM.getRecentTransfers()
                            }
                        } else {
                            
                            if homeVM.cards.isEmpty && homeVM.alertMessage.isEmpty {
                                AttachNewCardButton {
                                    viewRouter.pushHomePath(.attachCard)
                                }.padding(24)
                            }
                            
                            else {
                                
                                ACarousel(homeVM.cards,
                                          spacing: 10,
                                          headspace: 30,
                                          sidesScaling: 0.7) { card in
                                    UserCard(card: card, selected: card.defaultCard)
                                }.frame(height: 250)
                            }
                            
                            HomeMenu(cards: homeVM.cards)
                                .environmentObject(viewRouter)
                        }
                    }
                }
                
                if homeVM.loadingTransactions {
                    RecentTransactions(transactions: PreviewModels.transactionList) {
                        viewRouter.pushHomePath(.allTransactions)
                    }.redacted(reason: .placeholder)
                        .shimmering(
                            active: homeVM.loading,
                            animation: .easeInOut(duration: 1)
                                .repeatForever(autoreverses: false)
                        )
                } else {
                    RecentTransactions(transactions: homeVM.transactions) {
                        viewRouter.pushHomePath(.allTransactions)
                    }
                }
            }.padding(.top, 1)
                .refreshable {
                    homeVM.cards.removeAll(keepingCapacity: false)
                    homeVM.transactions.removeAll(keepingCapacity: false)
                    homeVM.getCards()
                    homeVM.getRecentTransfers()
                }
                .task {
                    homeVM.getCards()
                    homeVM.getRecentTransfers()
                }
                .navigationBarTitle(Text(""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            TextHelper(text: NSLocalizedString("good", comment: "") + " " + Date.now.getDayTime() + "!", colorResource: .appGray, fontName: .medium, fontSize: 12)
                            
                            TextHelper(text: Auth.auth().currentUser?.displayName ?? "", colorResource: .darkBlue, fontName: .bold, fontSize: 24)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewRouter.pushHomePath(.notifications)
                        } label: {
                            Image(homeVM.hasUnreadNotification ? "notification-unread" : "notification")
                        }
                    }
                    
                }.alert(NSLocalizedString("error", comment: ""), isPresented: $homeVM.showAlert, actions: {
                    Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
                }, message: {
                    Text(homeVM.alertMessage)
                })
                .navigationDestination(for: HomeViewPaths.self) { page in
                    viewRouter.buildHomeView(page: page)
                }
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: NotificationName.cardAttached.rawValue))) { _ in
            showCardAttachedAlert.toggle()
        }.fullScreenCover(isPresented: $showCardAttachedAlert, content: {
            CongratulationAlert {
                VStack(spacing: 12) {
                    TextHelper(text: NSLocalizedString("cardIsReady", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                    
                    TextHelper(text: NSLocalizedString("cardIsReadyMessage", comment: ""), colorResource: .appGray, fontSize: 12)
                    
                }
            } action: {
                showCardAttachedAlert = false
                viewRouter.popToHomeRoot()
            }
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    @StateObject var homeVM = HomeViewModel()
    static var previews: some View {
        
        HomeView()
            .environmentObject(ViewRouter())
    }
}
