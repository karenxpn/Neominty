//
//  CardStylingSelector.swift
//  Banking
//
//  Created by Karen Mirakyan on 28.03.23.
//

import SwiftUI

struct CardStylingSelector: View {
    @Binding var selectedItem: CardDesign
    let cardDesign: CardDesign
    
    var body: some View {
        
        Button {
            withAnimation {
                selectedItem = cardDesign
            }
        } label: {
            ZStack {
                Circle()
                    .trim(from: 0.5, to: 1)
                    .fill( cardDesign == .standardBlue || cardDesign == .standardBlueGreen || cardDesign == .hexBlue || cardDesign == .hexBlueGreen || cardDesign == .signedBlueGreen ? AppColors.darkBlue : AppColors.green
                    )
                    .frame(width: 24, height: 24)
                Circle()
                    .trim(from: 0, to: 0.5)
                    .fill(cardDesign == .standardGreen || cardDesign == .standardBlueGreen || cardDesign == .hexGreen || cardDesign == .hexBlueGreen || cardDesign == .signedBlueGreen ? AppColors.green : AppColors.darkBlue)
                    .frame(width: 24, height: 24)
                
                if selectedItem == cardDesign {
                    Image("check-white")
                    
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .frame(width: 28, height: 28)
                }
                
            }
        }
    }
}

struct CardStylingSelector_Previews: PreviewProvider {
    static var previews: some View {
        CardStylingSelector(selectedItem: .constant(.greenBlue), cardDesign: .greenBlue)
    }
}
