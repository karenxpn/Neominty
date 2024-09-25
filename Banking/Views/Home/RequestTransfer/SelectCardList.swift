//
//  SelectCardList.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import SwiftUI

struct SelectCardList: View {
    let cards: [CardModel]
    @Binding var selectedCard: CardModel?
    @Binding var show: Bool
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24) {
                
                TextHelper(text: NSLocalizedString("selectYourCard", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                    .padding(.top)
                
                ForEach(cards, id: \.id) { card in
                    ZStack( alignment: .trailing) {
                        SelectCardButton(card: card, buttonType: .button) {
                            selectedCard = card
                        }
                        
                        if selectedCard?.cardPan == card.cardPan {
                            Image("check")
                                .offset(x: -10)
                        }
                    }
                }
                
                ButtonHelper(disabled: false, label: NSLocalizedString("confirm", comment: "")) {
                    show.toggle()
                }.padding(.top, 80)
            }.padding(24)
        }.padding(.top, 1)
        
    }
}

struct SelectCardList_Previews: PreviewProvider {
    static var previews: some View {
        SelectCardList(cards: [PreviewModels.masterCard, PreviewModels.visaCard, PreviewModels.mirCard], selectedCard: .constant(PreviewModels.mirCard), show: .constant(false))
    }
}
