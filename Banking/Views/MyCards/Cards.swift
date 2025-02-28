//
//  Cards.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI
import Shimmer


struct Cards: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var cardsVM = CardsViewModel()
    @State private var showCardAttachedAlert: Bool = false

    var body: some View {
        NavigationStack(path: $viewRouter.cardPath) {
            ZStack {
                if cardsVM.loadingCards {
                    CardsList(cards: [PreviewModels.masterCard, PreviewModels.visaCard, PreviewModels.amexCard],
                              loading: $cardsVM.loadingCards)
                        .redacted(reason: .placeholder)
                            .shimmering(
                                active: cardsVM.loadingCards,
                                animation: .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: false)
                            )
                } else if cardsVM.cards.isEmpty && !cardsVM.loadingCards && cardsVM.alertMessage.isEmpty {
                    RequestToAddNewCard()
                } else if cardsVM.cards.isEmpty && !cardsVM.alertMessage.isEmpty && !cardsVM.loadingCards {
                    ViewFailedToLoad {
                        cardsVM.getCards()
                    }
                } else {
                    CardsList(cards: cardsVM.cards,
                              loading: $cardsVM.loadingCards)
                        .environmentObject(cardsVM)
                }
            }.navigationTitle(Text(""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextHelper(text: NSLocalizedString("myCards", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                    }
                }.task {
                    cardsVM.getCards()
                }.alert(NSLocalizedString("error", comment: ""), isPresented: $cardsVM.showAlert, actions: {
                    Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
                }, message: {
                    Text(cardsVM.alertMessage)
                })
                .navigationDestination(for: MyCardViewPaths.self) { value in
                    switch value {
                    case .attachCard:
                        SelectCardStyle()
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
                        viewRouter.popToCardRoot()
                    }
                })
        }
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        Cards()
            .environmentObject(ViewRouter())
    }
}
