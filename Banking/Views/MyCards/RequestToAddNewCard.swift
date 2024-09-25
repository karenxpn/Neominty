//
//  RequestToAddNewCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 28.03.23.
//

import SwiftUI

struct RequestToAddNewCard: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        ScrollView {
            VStack(spacing: 48) {
                Image("illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.3)
                
                VStack(alignment: .leading, spacing: 16) {
                    TextHelper(text: NSLocalizedString("createYourNeomintyCard", comment: ""),
                               colorResource: .darkBlue,
                               fontName: .bold,
                               fontSize: 32)
                    
                    TextHelper(text: NSLocalizedString("createYourCardMessage", comment: ""),
                               colorResource: .appGray,
                               fontSize: 16)
                }
                
                ButtonHelper(disabled: false, label: NSLocalizedString("attachCard", comment: "")) {
                    viewRouter.pushCardPath(.attachCard)
                }
            }.padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.padding(.top, 1)
    }
}

struct RequestToAddNewCard_Previews: PreviewProvider {
    static var previews: some View {
        RequestToAddNewCard()
    }
}
