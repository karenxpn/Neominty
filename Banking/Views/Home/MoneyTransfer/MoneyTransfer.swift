//
//  MoneyTransfer.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct MoneyTransfer: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var transferVM: TransferViewModel
    let cards: [CardModel]
    
    @State private var cardType = CardBankType.nonIdentified
    
    init(cards: [CardModel]) {
        self.cards = cards
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
                                transferVM.selectedCard = card
                            } label: {
                                UserCard(card: card, selected: card.id == transferVM.selectedCard?.id)
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                            }
                        }
                    }.padding(.horizontal, 20)
                }
                
                
                VStack(alignment: .leading, spacing: 15) {
                    TextHelper(text: NSLocalizedString("enterReceiverDetails", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                        .padding(.top, 13)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image("card-placeholder")
                            
                            CardValidationTF(text: $transferVM.cardNumber,
                                             isValid: $transferVM.isCardValid,
                                             bankCardType: $cardType,
                                             tfType: .cardNumber,
                                             tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                             subtitle: "**** **** **** ****")
                            
                        }.padding(19)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(transferVM.cardNumber.onlyNumbers().count == 16 && !transferVM.isCardValid ? Color.red : Color.clear, lineWidth: 1)
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.superLightGray)
                                    }
                                
                            }
                        
                        if transferVM.cardNumber.onlyNumbers().count == 16 && !transferVM.isCardValid {
                            TextHelper(text: NSLocalizedString("cardNotValid", comment: ""),
                                       color: .red, fontName: Roboto.regular.rawValue, fontSize: 10)
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
                            TextHelper(text: NSLocalizedString("noRecentTransactions", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity)
                                .padding(.vertical, UIScreen.main.bounds.height * 0.1)
                        } else {
                            TextHelper(text: NSLocalizedString("recentTransactions", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                            
                            RecentTransferUsersList(card: $transferVM.cardNumber, selected: $transferVM.selectedTransfer, transfers: transferVM.transactionUsers)
                        }
                                                
                        ButtonHelper(disabled: transferVM.selectedCard == nil || !transferVM.isCardValid, label: NSLocalizedString("continue", comment: "")) {
                            viewRouter.pushHomePath(.transferDetails)
                            
                        }.padding(.top, 20)
                    }.padding(.horizontal, 20)
                }
                
            }.padding(.bottom, UIScreen.main.bounds.height * 0.2)
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitle(Text(""), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(alignment: .leading, spacing: 4) {
                    TextHelper(text: NSLocalizedString("transfer", comment: ""), color: .black, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
                
            }
        }.task {
                transferVM.getRecentTransfers()
                transferVM.selectedCard = cards.first(where: { $0.defaultCard })
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $transferVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(transferVM.alertMessage)
            })
    }
}

struct MoneyTransfer_Previews: PreviewProvider {
    static var previews: some View {
        MoneyTransfer(cards: [PreviewModels.masterCard, PreviewModels.visaCard])
            .environmentObject(ViewRouter())
            .environmentObject(TransferViewModel())
    }
}
