//
//  MoneyTransfer.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI
import ACarousel

struct MoneyTransfer: View {
    @EnvironmentObject var router: Router
    @StateObject private var transferVM = TransferViewModel()
    let cards: [CardModel]
    @State private var selectedCard: String??
    
    @State private var cardNumber: String = ""
    @State private var cardType = CreditCardType.nonIdentified
    @State private var isCardValid: Bool = false
    @State private var cardIndex: Int = 0
    
    
    init(cards: [CardModel]) {
        self.cards = cards
        _selectedCard = State(initialValue: cards.first(where: { $0.defaultCard })?.id)
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 16) {
                
                TextHelper(text: String(localized: .chooseCard), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                    .padding(.leading, 20)
                
                if cards.isEmpty {
                    AttachNewCardButton {
                        router.pushHomePath(.attachCard)
                    }.padding(.horizontal)
                } else {
                    ACarousel(cards,
                              index: $cardIndex,
                              spacing: 10,
                              headspace: 30,
                              sidesScaling: 0.7) { card in
                        UserCard(card: card, selected: card.id == selectedCard)
                    }.frame(height: 250)
                        .onChange(of: cardIndex) { oldValue, newValue in
                            selectedCard = cards.get(newValue)?.id
                        }
                }
                
                
                VStack(alignment: .leading, spacing: 15) {
                    TextHelper(text: String(localized: .enterReceiverDetails), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            
                            if cardType == .nonIdentified {
                                Image("card-placeholder")
                            } else {
                                Image(cardType.textFieldIcon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 22.5, height: 18)
                                    .clipped()
                            }
                            
                            CardValidationTF(text: $cardNumber,
                                             isValid: $isCardValid,
                                             bankCardType: $cardType,
                                             tfType: .cardNumber,
                                             tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                             subtitle: "**** **** **** ****")
                            .onChange(of: cardNumber) { _, value in
                                transferVM.selectedTransfer = transferVM
                                    .transactionUsers
                                    .first(where: { $0.card.filter { !$0.isWhitespace } == value.filter { !$0.isWhitespace } })
                            }
                            
                        }.padding(19)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(cardNumber.onlyNumbers().count == 16 && !isCardValid ? Color.red : Color.clear, lineWidth: 1)
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(.superLightGray))
                                    }
                            }
                        
                        if cardNumber.onlyNumbers().count == 16 && !isCardValid {
                            TextHelper(text: String(localized: .cardNotValid),
                                       color: .red, fontName: .regular, fontSize: 10)
                        }
                    }
                    
                }.padding(.horizontal, 20)
                
                
                if transferVM.loading {
                    ProgressView()
                        .frame(minWidth: 0,
                               maxWidth: .infinity)
                        .padding(.vertical, UIScreen.main.bounds.height * 0.1)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        if transferVM.transactionUsers.isEmpty {
                            TextHelper(text: String(localized: .noRecentTransactions), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity)
                                .padding(.vertical, UIScreen.main.bounds.height * 0.1)
                        } else {
                            TextHelper(text: String(localized: .recentTransactions), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                            
                            RecentTransferUsersList(card: $cardNumber, selected: $transferVM.selectedTransfer, transfers: transferVM.transactionUsers)
                        }
                        
                        ButtonHelper(disabled: selectedCard == nil || !isCardValid, label: String(localized: .`continue`)) {
                            if let card = cards.first(where: {$0.id == selectedCard}) {
                                router.pushHomePath(.transferDetails(card: card,
                                                                         recentTransfer: transferVM.selectedTransfer,
                                                                         receiverCardNumber: cardNumber))
                            }
                        }.padding(.top, 20)
                    }.padding(.horizontal, 20)
                }
                
            }.padding(.bottom, UIScreen.main.bounds.height * 0.2)
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(Text(""))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextHelper(text: String(localized: .transfer), color: .black, fontName: .bold, fontSize: 20)
                    }
                    
                }
            }.task {
                transferVM.getRecentTransfers()
            }.alert(String(localized: .error), isPresented: $transferVM.showAlert, actions: {
                Button(String(localized: .gotIt), role: .cancel) { }
            }, message: {
                Text(transferVM.alertMessage)
            })
    }
}

struct MoneyTransfer_Previews: PreviewProvider {
    static var previews: some View {
        MoneyTransfer(cards: [PreviewModels.masterCard, PreviewModels.visaCard])
            .environmentObject(Router())
    }
}



extension Array {
    func get(_ index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
