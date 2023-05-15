//
//  UserCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct UserCard: View {
    let card: CardModel
    let selected: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                
                Image("chip")
                Image("wifi")
                
                Spacer()
                
                if selected {
                    Image("check")
                }
            }.padding([.horizontal, .top], 20)
            
            VStack(alignment: .leading, spacing: 6) {
                TextHelper(text: card.cardPan, color: .white, fontName: Roboto.bold.rawValue, fontSize: 14)
                TextHelper(text: card.expirationDate, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
            }.padding(.horizontal, 20)
                .padding(.top, 13)
            
            HStack {
                TextHelper(text: card.cardHolder, color: .white, fontName: Roboto.bold.rawValue, fontSize: 14)
                Spacer()
                Image(card.cardType.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 26)
            }.padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background {
                    if card.cardStyle == .blueGreen {
                        AppColors.green
                    } else if card.cardStyle == .greenBlue {
                        AppColors.darkBlue
                    }
                }
        }.background {
            if card.cardStyle == .blue || card.cardStyle == .blueGreen {
                ZStack(alignment: .trailing) {
                    AppColors.darkBlue
                    if card.cardStyle == .blue {
                        CardHexDesign()
                    } else {
                        Image("card-sign")
                            .resizable()
                    }
                }
            } else if card.cardStyle == .green || card.cardStyle == .greenBlue {
                
                ZStack(alignment: .trailing) {
                    AppColors.green
                    if card.cardStyle == .green {
                        CardHexDesign()
                    } else {
                        Image("card-sign")
                            .resizable()
                    }
                }
            }
        }
        .cornerRadius(16)
    }
}

struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        UserCard(card: PreviewModels.masterCard, selected: true)
    }
}
