//
//  SelectCardStyle.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.05.23.
//

import SwiftUI
import FirebaseFirestore

struct SelectCardStyle: View {
    let styles: [CardDesign] = [.hex, .signed, .standard]
    let standardCard = CardModel(cardPan: "xxxx xxxx xxxx xxxx", cardHolder: "John Smith", expirationDate: "13/24", currency: .usd, bankName: "American Bank", defaultCard: false, cardStyle: .standardGreen, cardType: .masterCard, createdAt: Timestamp(date: Date()), bindingId: "")
    
    let hexCard = CardModel(cardPan: "xxxx xxxx xxxx xxxx", cardHolder: "John Smith", expirationDate: "13/24", currency: .usd, bankName: "American Bank", defaultCard: false, cardStyle: .hexBlue, cardType: .masterCard, createdAt: Timestamp(date: Date()), bindingId: "")
    
    let signedCard = CardModel(cardPan: "xxxx xxxx xxxx xxxx", cardHolder: "John Smith", expirationDate: "13/24", currency: .usd, bankName: "American Bank", defaultCard: false, cardStyle: .signedBlueGreen, cardType: .masterCard, createdAt: Timestamp(date: Date()), bindingId: "")
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            LazyVStack(spacing: 16) {
                ForEach(styles, id: \.id) { style in
                    NavigationLink(value: style) {
                        switch style {
                        case .standard:
                            SelectCardStyleCell(style: style, card: standardCard)
                        case .hex:
                            SelectCardStyleCell(style: style, card: hexCard)
                        case .signed:
                            SelectCardStyleCell(style: style, card: signedCard)
                        default:
                            EmptyView()
                        }
                    }
                }
            }.padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
        }.padding(.top, 1)
            .navigationTitle(Text(""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextHelper(text: NSLocalizedString("chooseYourStyle", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                    }
                }.navigationDestination(for: CardDesign.self) { design in
                    AddNewCard(style: design)
                }
        
    }
}

struct SelectCardStyle_Previews: PreviewProvider {
    static var previews: some View {
        SelectCardStyle()
    }
}

struct SelectCardStyleCell: View {
    let style: CardDesign
    let card: CardModel
    
    var body: some View {
        switch style {
        case .standard:
            StandardStyles(card: card, selected: false)
        case .hex:
            HexagonStyles(card: card, selected: false)
        case .signed:
            SignedStyle(card: card, selected: false)
            
        default:
            EmptyView()
        }
    }
}
