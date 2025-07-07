//
//  RequestToAddNewCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 28.03.23.
//

import SwiftUI

struct RequestToAddNewCard: View {
    
    @EnvironmentObject var router: Router
    var body: some View {
        ScrollView {
            VStack(spacing: 48) {
                Image("illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.3)
                
                VStack(alignment: .leading, spacing: 16) {
                    TextHelper(text: String(localized: .createYourNeomintyCard),
                               colorResource: .darkBlueText,
                               fontName: .bold,
                               fontSize: 32)
                    
                    TextHelper(text: String(localized: .createYourCardMessage),
                               colorResource: .appGray,
                               fontSize: 16)
                }
                
                ButtonHelper(disabled: false, label: String(localized: .attachCard)) {
                    router.pushCardPath(.selectNewCardStyle)
                }
            }.padding(24)
        }.padding(.top, 1)
    }
}

struct RequestToAddNewCard_Previews: PreviewProvider {
    static var previews: some View {
        RequestToAddNewCard()
    }
}
