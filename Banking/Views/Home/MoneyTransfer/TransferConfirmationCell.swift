//
//  TransferConfirmationCell.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI

struct TransferConfirmationCell: View {
    
    let direction: String
    let bank: String
    let name: String
    let card: String
    
    var body: some View {
        
        VStack(spacing: 8) {
            HStack {
                TextHelper(text: direction, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                Spacer()
                TextHelper(text: bank, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
            }
            
            HStack {
                TextHelper(text: name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                Spacer()
                TextHelper(text: card, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
            }
            
            Divider()
                .padding(.top)
        }
    }
}

struct TransferConfirmationCell_Previews: PreviewProvider {
    static var previews: some View {
        TransferConfirmationCell(direction: "From", bank: "Bank of America", name: "Tonny", card: "**** 1121")
    }
}
