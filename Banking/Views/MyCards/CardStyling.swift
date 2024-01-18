//
//  CardStyling.swift
//  Banking
//
//  Created by Karen Mirakyan on 28.03.23.
//

import SwiftUI
import FirebaseFirestore

struct CardStyling: View {
    
    @Binding var cardNumber: String
    @Binding var cardType: CreditCardType
    @Binding var cardHolder: String
    @Binding var expireDate: String
    @Binding var cardDesign: CardDesign
    
    var card: CardModel
    
    init(cardNumber: Binding<String>, cardType: Binding<CreditCardType>, cardHolder: Binding<String>, expireDate: Binding<String>, cardDesign: Binding<CardDesign>) {
        self._cardNumber = cardNumber
        self._cardType = cardType
        self._cardHolder = cardHolder
        self._expireDate = expireDate
        self._cardDesign = cardDesign
        
        self.card = CardModel(cardPan: cardNumber.wrappedValue.isEmpty ? "xxxx xxxx xxxx xxxx" : cardNumber.wrappedValue,
                              cardHolder: cardHolder.wrappedValue.isEmpty ? "John Smith" : cardHolder.wrappedValue ,
                              expirationDate: expireDate.wrappedValue.isEmpty ? "MM/YYYY" : expireDate.wrappedValue,
                              bankName: "",
                              cardStyle: cardDesign.wrappedValue,
                              cardType: .masterCard, createdAt: Timestamp(date: Date()), bindingId: "")
    }
    
    var body: some View {
        
        switch cardDesign {
        case .standardBlue, .standardGreen, .standardBlueGreen, .standardGreenBlue:
            StandardStyles(card: card, selected: false)
        case .hexBlue, .hexGreen, .hexBlueGreen, .hexGreenBlue:
            HexagonStyles(card: card, selected: false)
        case .signedGreenBlue, .signedBlueGreen:
            SignedStyle(card: card, selected: false)
        default:
            EmptyView()
        }
    }
}

struct CardStyling_Previews: PreviewProvider {
    static var previews: some View {
        CardStyling(cardNumber: .constant(""), cardType: .constant(.maestro), cardHolder: .constant(""), expireDate: .constant(""), cardDesign: .constant(.blue))
    }
}
