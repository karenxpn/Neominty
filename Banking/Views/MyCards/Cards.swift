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
        if cardsVM.loading {
            ProgressView()
        } else if cardsVM.cards.isEmpty && !cardsVM.loading {
            Text("add card")
        } else {
            Text("cards list")
        }
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        Cards()
            .environmentObject(ViewRouter())
    }
}
