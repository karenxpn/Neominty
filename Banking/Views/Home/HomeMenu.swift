//
//  HomeMenu.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct HomeMenu: View {
    @EnvironmentObject var router: Router
    
    let icons = ["money-send", "money-exchange", "money-receive", "more"]
    let labels = [String(localized: .send),
                  String(localized: .pay),
                  String(localized: .request),
                  String(localized: .more)]
    let cards: [CardModel]
    let paths: [HomeViewPaths]
    
    init(cards: [CardModel]) {
        self.cards = cards
        self.paths = [.send(cards: cards),
                        .pay,
                        .receive,
                        .more]
    }
    
    var body: some View {
        HStack {
            ForEach(0..<icons.count, id: \.self) { id in
                HomeMenuItem(icon: icons[id], label: labels[id]) {
                    router.pushHomePath(paths[id])
                }.environmentObject(router)
            }
        }.padding(.vertical, 15)
            .background(Color(.whiteOpacity))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct HomeMenu_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenu(cards: [])
            .environmentObject(Router())
    }
}
