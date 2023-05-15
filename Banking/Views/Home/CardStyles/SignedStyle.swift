//
//  SignedStyle.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.05.23.
//

import SwiftUI

struct SignedStyle: View {
    let card: CardModel
    let selected: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                
                Image("chip")
                Image("wifi")
                
                Spacer()
                
                if selected {
                    Image( card.cardStyle == .signedGreenBlue ? "check-blue" : "check")
                }
            }.padding([.horizontal, .top], 20)
            
            VStack(alignment: .leading, spacing: 6) {
                TextHelper(text: card.cardPan, color: .white, fontName: Roboto.bold.rawValue, fontSize: 14)
                TextHelper(text: card.expirationDate, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
            }.padding(.horizontal, 20)
                .padding(.top, 13)
            
            HStack {
                TextHelper(text: card.cardHolder, color: .white, fontName: Roboto.medium.rawValue, fontSize: 14)
                Spacer()
                Image(card.cardType.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 26)
            }.padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background {
                    if card.cardStyle == .signedBlueGreen {
                        AppColors.green
                    } else if card.cardStyle == .signedGreenBlue {
                        AppColors.darkBlue
                    }
                }
        }.background {
            ZStack(alignment: .trailing) {
                card.cardStyle == .signedGreenBlue ? AppColors.green : AppColors.darkBlue
                Image("card-sign")
                    .resizable()
                    .foregroundColor(card.cardStyle == .signedBlueGreen ? AppColors.green : AppColors.darkBlue)
            }
        }
        .cornerRadius(16)
    }
}

struct SignedStyle_Previews: PreviewProvider {
    static var previews: some View {
        SignedStyle(card: PreviewModels.masterCard, selected: true)
    }
}
