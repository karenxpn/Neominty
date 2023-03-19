//
//  MoneyTransfer.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct MoneyTransfer: View {
    @StateObject private var transferVM = TransferViewModel()
    let cards: [CardModel]
    @State private var selectedCard: CardModel?
    
    @State private var cardType = CardBankType.nonIdentified
    @State private var isCardValid: Bool = false
    
    init(cards: [CardModel]) {
        self.cards = cards
        _selectedCard = State(initialValue: cards.first(where: { $0.defaultCard }))
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 16) {
                
                TextHelper(text: NSLocalizedString("chooseCard", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    .padding(.leading, 20)
                
                ScrollView( .horizontal, showsIndicators: false ) {
                    LazyHStack(spacing: 16) {
                        ForEach( cards, id: \.id ) { card in
                            Button {
                                selectedCard = card
                            } label: {
                                UserCard(card: card, selected: card.id == selectedCard?.id)
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                            }
                        }
                    }.padding(.horizontal, 20)
                }
                
                
                VStack(alignment: .leading, spacing: 15) {
                    TextHelper(text: NSLocalizedString("enterReceiverDetails", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                        .padding(.top, 13)
                    
                    HStack {
                        Image("card-placeholder")
                        
                        CardValidationTF(text: $transferVM.cardNumber,
                                         isValid: $isCardValid,
                                         bankCardType: $cardType,
                                         tfType: .cardNumber,
                                         tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                         subtitle: "**** **** **** ****")
                        
                    }.padding(19)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.superLightGray)
                        }
                    
                }.padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    if transferVM.transactionUsers.isEmpty {
                        TextHelper(text: NSLocalizedString("noRecentTransactions", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity)
                            .padding(.vertical, UIScreen.main.bounds.height * 0.1)
                    }
                    
                    ButtonHelper(disabled: selectedCard == nil || !isCardValid, label: NSLocalizedString("continue", comment: "")) {
                        transferVM.selectedCard = selectedCard
                    }
                }.padding(.horizontal, 20)
                
            }.padding(.bottom, UIScreen.main.bounds.height * 0.2)
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
        .navigationTitle(Text(NSLocalizedString("transfer", comment: "")))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct MoneyTransfer_Previews: PreviewProvider {
    static var previews: some View {
        MoneyTransfer(cards: [PreviewModels.masterCard, PreviewModels.visaCard])
    }
}
