//
//  HomeMenuItem.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct HomeMenuItem: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let icon: String
    let label: String
    var action: () -> ()

    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    Image(icon)
                    
                    TextHelper(text: label, colorResource: .darkBlue, fontName: Roboto.medium.rawValue, fontSize: 12)
                }
                Spacer()
            }
        }
        
        
    }
}

struct HomeMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenuItem(icon: "money-send", label: NSLocalizedString("send", comment: ""), action: {
            
        }).environmentObject(ViewRouter())
    }
}
