//
//  Cards.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct Cards: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var cardsVM = CardsViewModel()
    
    var body: some View {
        NavigationStack(path: $viewRouter.cardPath) {
            ZStack {
                if cardsVM.loading {
                    ProgressView()
                } else if cardsVM.cards.isEmpty && !cardsVM.loading {
                    RequestToAddNewCard()
                } else {
                    CardsList(cards: cardsVM.cards)
                }
            }.navigationTitle(Text(""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextHelper(text: NSLocalizedString("myCards", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
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
                        AddNewCard()
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
