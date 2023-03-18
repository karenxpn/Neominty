//
//  HomeMenu.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct HomeMenu: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let icons = ["money-send", "money-exchange", "money-receive", "more"]
    let labels = [NSLocalizedString("send", comment: ""),
    NSLocalizedString("exchange", comment: ""),
    NSLocalizedString("request", comment: ""),
    NSLocalizedString("more", comment: "")]
    let paths = [HomeViewPaths.send,
                 HomeViewPaths.exchange,
                 HomeViewPaths.receive,
                 HomeViewPaths.more]
    
    var body: some View {
        HStack {
            ForEach(0..<icons.count, id: \.self) { id in
                HomeMenuItem(icon: icons[id], label: labels[id]) {
                    viewRouter.pushHomePath(paths[id])
                }.environmentObject(viewRouter)
            }
        }
    }
}

struct HomeMenu_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenu()
            .environmentObject(ViewRouter())
    }
}
