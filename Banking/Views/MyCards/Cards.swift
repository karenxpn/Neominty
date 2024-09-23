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
                        TextHelper(text: NSLocalizedString("myCards", comment: ""), colorResource: .darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
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
                }
        }
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        Cards()
            .environmentObject(ViewRouter())
    }
}
