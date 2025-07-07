//
//  NoTransactionsToShow.swift
//  Banking
//
//  Created by Karen Mirakyan on 17.05.23.
//

import SwiftUI

struct NoTransactionsToShow: View {
    var body: some View {
        HStack(spacing: 16) {
            
            IconGenerator(icon: "wallet-green")
            
            VStack(alignment: .leading, spacing: 4) {
                TextHelper(text: String(localized: .nothingToShow), colorResource: .darkBlueText, fontName: .bold, fontSize: 14)
                TextHelper(text: String(localized: .makeYourFirstTransaction), colorResource: .appGray, fontName: .medium, fontSize: 12)
            }
            
            Spacer()
        }
    }
}

struct NoTransactionsToShow_Previews: PreviewProvider {
    static var previews: some View {
        NoTransactionsToShow()
    }
}
