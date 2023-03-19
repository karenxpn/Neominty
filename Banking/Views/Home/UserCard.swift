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
        
        VStack(alignment: .leading, spacing: 36) {
            HStack(spacing: 10) {
                
                Image("chip")
                Image("wifi")
                
                Spacer()
                
                if selected {
                    Image("check")
                }
            }.padding([.horizontal, .top], 20)
            
            VStack(alignment: .leading, spacing: 6) {
                TextHelper(text: card.number, color: .white, fontName: Roboto.bold.rawValue, fontSize: 14)
                TextHelper(text: card.expirationDate, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
            }.padding(.horizontal, 20)
            
            HStack {
                TextHelper(text: card.cardHolder, color: .white, fontName: Roboto.bold.rawValue, fontSize: 20)
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
                .background {
                    if card.design == .blueGreen {
                        AppColors.green
                    } else if card.design == .greenBlue {
                        AppColors.darkBlue
                    }
                }
        }.background {
            if card.design == .blue || card.design == .blueGreen {
                ZStack(alignment: .trailing) {
                    AppColors.darkBlue
                    if card.design == .blue {
                        CardHexDesign()
                    } else {
                        Image("card-sign")
                            .resizable()
                    }
                }
            } else if card.design == .green || card.design == .greenBlue {
                
                ZStack(alignment: .trailing) {
                    AppColors.green
                    if card.design == .green {
                        CardHexDesign()
                    } else {
                        Image("card-sign")
                            .resizable()
                    }
                }
            }
        }
        .cornerRadius(16)
        .frame(
              minWidth: 0,
              maxWidth: UIScreen.main.bounds.width
            )
    }
}

struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        UserCard(card: PreviewModels.masterCard, selected: true)
    }
}
