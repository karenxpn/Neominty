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
        
        switch card.cardStyle {
        case .standardBlue, .standardGreen, .standardBlueGreen, .standardGreenBlue:
            StandardStyles(card: card, selected: selected)
        case .hexBlue, .hexGreen, .hexBlueGreen, .hexGreenBlue:
            HexagonStyles(card: card, selected: selected)
        case .signedBlueGreen, .signedGreenBlue:
            SignedStyle(card: card, selected: selected)
        default:
            EmptyView()
        }
    }
}

struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        UserCard(card: PreviewModels.amexCard, selected: true)
    }
}
