//
//  CardStyling.swift
//  Banking
//
//  Created by Karen Mirakyan on 28.03.23.
//

import SwiftUI

struct CardStyling: View {
    
    @Binding var cardNumber: String
    @Binding var cardType: CardBankType
    @Binding var cardHolder: String
    @Binding var expireDate: String
    @Binding var cardDesign: CardDesign
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 36) {
            HStack(spacing: 10) {
                
                Image("chip")
                Image("wifi")
                
                Spacer()
                
            }.padding([.horizontal, .top], 20)
            
            VStack(alignment: .leading, spacing: 6) {
                TextHelper(text: cardNumber.isEmpty ? "0000 0000 0000 0000" : cardNumber, color: .white, fontName: Roboto.bold.rawValue, fontSize: 14)
                
                TextHelper(text: expireDate.isEmpty ? "00/00" : expireDate, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
            }.padding(.horizontal, 20)
            
            HStack {
                TextHelper(text: cardHolder.isEmpty ? NSLocalizedString("yourName", comment: "") : cardHolder,
                           color: .white,
                           fontName: Roboto.bold.rawValue,
                           fontSize: 20)
                
                Spacer()
                
                Image(cardType.textFieldIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 26)
                
            }.padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background {
                    if cardDesign == .blueGreen {
                        AppColors.green
                    } else if cardDesign == .greenBlue {
                        AppColors.darkBlue
                    }
                }
        }.background {
            if cardDesign == .blue || cardDesign == .blueGreen {
                ZStack(alignment: .trailing) {
                    AppColors.darkBlue
                    if cardDesign == .blue {
                        CardHexDesign()
                    } else {
                        Image("card-sign")
                            .resizable()
                    }
                }
            } else if cardDesign == .green || cardDesign == .greenBlue {
                
                ZStack(alignment: .trailing) {
                    AppColors.green
                    if cardDesign == .green {
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

struct CardStyling_Previews: PreviewProvider {
    static var previews: some View {
        CardStyling(cardNumber: .constant(""), cardType: .constant(.maestro), cardHolder: .constant(""), expireDate: .constant(""), cardDesign: .constant(.blue))
    }
}
