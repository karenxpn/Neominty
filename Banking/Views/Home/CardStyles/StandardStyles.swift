//
//  StandardStyles.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.05.23.
//

import SwiftUI

struct StandardStyles: View {
    let card: CardModel
    let selected: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 10) {
                
                Image("chip")
                Image("wifi")
                
                Spacer()
                
                if selected {
                    Image(card.cardStyle == .blue ? "check" : "check-blue")
                }
            }.padding([.horizontal, .top], 20)
            
            VStack(alignment: .leading, spacing: 6) {
                TextHelper(text: card.cardPan, color: .white, fontName: .bold, fontSize: 14)
                TextHelper(text: card.expirationDate, colorResource: .appGray, fontSize: 12)
            }.padding(.horizontal, 20)
                .padding(.top, 19)
            
            HStack {
                TextHelper(text: card.cardHolder, color: .white, fontName: .medium, fontSize: 14)
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
                case .standardBlue:
                    Color(.darkBlue)
                case .standardGreen:
                    Color(.appGreen)
                case .standardGreenBlue:
                    LinearGradient(gradient: Gradient(colors: [Color(.appGreen), Color(.darkBlue)]), startPoint: .leading, endPoint: .trailing)
                case .standardBlueGreen:
                    LinearGradient(gradient: Gradient(colors: [Color(.darkBlue), Color(.appGreen)]), startPoint: .leading, endPoint: .trailing)
                default:
                    Color(.darkBlue)
                }
            }
        }
        .cornerRadius(16)
    }
}

struct StandardStyles_Previews: PreviewProvider {
    static var previews: some View {
        StandardStyles(card: PreviewModels.amexCard, selected: true)
        StandardStyles(card: PreviewModels.visaCard, selected: false)
        StandardStyles(card: PreviewModels.masterCard, selected: false)
        StandardStyles(card: PreviewModels.mirCard, selected: false)
    }
}
