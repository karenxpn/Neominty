//
//  ActivityCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 24.03.23.
//

import SwiftUI

struct ActivityCard: View {
    let card: CardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    TextHelper(text: card.cardPan, color: .white, fontName: Roboto.medium.rawValue, fontSize: 14)
                    TextHelper(text: card.cardHolder, color: .white, fontName: Roboto.medium.rawValue, fontSize: 20)
                }
                
                Spacer()
                if card.cardType == .masterCard {
                    Image("mc_symbol")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 26)
                } else if card.cardType == .visa {
                    Image("visa")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 26)
                }
            }.padding(.vertical, 16)
                .padding(.horizontal, 20)
        }.background {
            
            switch card.cardStyle {
            case .standardBlue, .hexBlue:
                AppColors.darkBlue
            case .standardGreen, .hexGreen:
                AppColors.green
            case .standardBlueGreen, .hexBlueGreen:
                LinearGradient(gradient: Gradient(colors: [AppColors.darkBlue, AppColors.green]), startPoint: .topLeading, endPoint: .bottomTrailing)
            case .standardGreenBlue, .hexGreenBlue:
                LinearGradient(gradient: Gradient(colors: [AppColors.green, AppColors.darkBlue]), startPoint: .topLeading, endPoint: .bottomTrailing)
            case .signedBlueGreen, .signedGreenBlue:
                ZStack(alignment: .trailing) {
                    card.cardStyle == .signedBlueGreen ? AppColors.darkBlue : AppColors.green
                    Image("card-sign")
                        .resizable()
                }
            default:
                EmptyView()
            }

        }
        .cornerRadius(16)
        .frame(
            minWidth: 0,
            maxWidth: UIScreen.main.bounds.width * 0.9
        )
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(card: PreviewModels.masterCard)
    }
}
