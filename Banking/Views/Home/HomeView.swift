//
//  HomeView.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI
import CollectionViewPagingLayout
import Shimmer

struct HomeView: View {
    @AppStorage("fullName") var localName: String = ""
    
    @EnvironmentObject private var viewRouter: ViewRouter
    @StateObject private var homeVM = HomeViewModel()
    @StateObject var transferVM = TransferViewModel()
    @State private var showCardAttachedAlert: Bool = false
    
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
                            
                            TextHelper(text: NSLocalizedString("good", comment: "") + " " + Date.now.getDayTime() + "!", color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                            
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
                    viewRouter.buildHomeView(page: page)
                }
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: NotificationName.cardAttached.rawValue))) { _ in
            showCardAttachedAlert.toggle()
        }.fullScreenCover(isPresented: $showCardAttachedAlert, content: {
            CongratulationAlert {
                VStack(spacing: 12) {
                    TextHelper(text: NSLocalizedString("cardIsReady", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    
                    TextHelper(text: NSLocalizedString("cardIsReadyMessage", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                    
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
