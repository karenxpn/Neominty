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
            
            Image("wallet-green")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                TextHelper(text: NSLocalizedString("nothingToShow", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)
                        TextHelper(text: NSLocalizedString("makeYourFirstTransaction", comment: ""), color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
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
