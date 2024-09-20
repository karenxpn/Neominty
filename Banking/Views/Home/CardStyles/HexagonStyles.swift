//
//  HexagonStyles.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.05.23.
//

import SwiftUI

struct HexagonStyles: View {
    let card: CardModel
    let selected: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                
                Image("chip")
                Image("wifi")
                
                Spacer()
                
                if selected {
                    Image(card.cardStyle == .hexGreen || card.cardStyle == .hexBlueGreen ? "check-blue" : "check")
                }
            }.padding([.horizontal, .top], 20)
            
            VStack(alignment: .leading, spacing: 6) {
                TextHelper(text: card.cardPan, color: .white, fontName: Roboto.bold.rawValue, fontSize: 14)
                TextHelper(text: card.expirationDate, color: AppColors.appGray, fontName: Roboto.regular.rawValue, fontSize: 12)
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
        }.background {
            ZStack(alignment: .trailing) {
                switch card.cardStyle {
                case .hexBlue:
                    AppColors.darkBlue
                case .hexGreen:
                    AppColors.appGreen
                case .hexGreenBlue:
                    LinearGradient(gradient: Gradient(colors: [AppColors.appGreen, AppColors.darkBlue]), startPoint: .leading, endPoint: .trailing)
                case .hexBlueGreen:
                    LinearGradient(gradient: Gradient(colors: [AppColors.darkBlue, AppColors.appGreen]), startPoint: .leading, endPoint: .trailing)
                default:
                    AppColors.darkBlue
                }
                
                CardHexDesign()
            }
        }
        .cornerRadius(16)
    }
}

struct HexagonStyles_Previews: PreviewProvider {
    static var previews: some View {
        HexagonStyles(card: PreviewModels.masterCard, selected: true)
        HexagonStyles(card: PreviewModels.visaCard, selected: true)
        HexagonStyles(card: PreviewModels.amexCard, selected: true)
        HexagonStyles(card: PreviewModels.mirCard, selected: true)
    }
}
