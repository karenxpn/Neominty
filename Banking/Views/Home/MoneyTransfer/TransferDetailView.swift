//
//  TransferDetailView.swift
//  Banking
//
//  Created by Karen Mirakyan on 21.03.23.
//

import SwiftUI

struct TransferDetailView: View {
    @StateObject var transferVM =  TransferViewModel()
    @EnvironmentObject var router: Router
    
    let card: CardModel
    let selectedTransfer: RecentTransfer?
    let receiverCardNumber: String
    
    @State private var isNameValid: Bool = false
    @State private var cardHolder: String = ""
    @State private var cardType = CreditCardType.nonIdentified
    @State private var navigateToConfirmation: Bool = false

    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 24) {
                
                if let recentTransfer = selectedTransfer {
                    
                    ZStack {
                        Circle()
                            .fill(recentTransfer.color)
                            .frame(width: 90, height: 90)

                        TextHelper(text: String(recentTransfer.name.first!),
                                   color: .white,
                                   fontName: .bold,
                                   fontSize: 35)
                    }
                    
                    TextHelper(text: "\(NSLocalizedString("to", comment: "")) \(recentTransfer.name)",
                               colorResource: .darkBlueText,
                               fontName: .bold,
                               fontSize: 14)
                    
                } else {
                    
                    ZStack {
                        Circle()
                            .fill(transferVM.randomColor)
                            .frame(width: 90, height: 90)

                        
                        let first = !cardHolder.isEmpty ? String(cardHolder[cardHolder.startIndex]) : ""
                        TextHelper(text: first,
                                   color: .white,
                                   fontName: .bold,
                                   fontSize: 35)
                    }
                    
                    CardValidationTF(text: $cardHolder,
                                     isValid: $isNameValid,
                                     bankCardType: $cardType,
                                     tfType: .cardHolder,
                                     tfFont: .custom(Roboto.bold.rawValue, size: 14),
                                     tfColor: Color(.darkBlue),
                                     subtitle: NSLocalizedString("enterFullName", comment: ""))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(!isNameValid && !cardHolder.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.superLightGray))
                            }
                        
                    }
                }
                
                VStack {
                    HStack {
                        TextHelper(text: NSLocalizedString("enterAmount", comment: ""), colorResource: .appGray,
                                   fontName: .medium, fontSize: 12)
                        
                        Spacer()
                        
                        TextHelper(text: NSLocalizedString("max $12,652", comment: ""), colorResource: .appGray,
                                   fontName: .medium, fontSize: 12)
                    }.padding(16)
                    
                    HStack {
                        TextHelper(text: "\(card.currency.rawValue)", colorResource: .appGray, fontName: .medium, fontSize: 16)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.lightGray))
                            }
                        
                        AmountTextField(text: $transferVM.transferAmount, fontSize: 24)
                        
                        
                    }.padding([.horizontal, .bottom], 16)
                }.background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(.lightGray), lineWidth: 1)
                }
                
                // add amount validation
                ButtonHelper(disabled: (!isNameValid && selectedTransfer == nil) || transferVM.transferAmount.isEmpty, label: NSLocalizedString("sendMoney", comment: "")) {
                    hideKeyboard()
                    navigateToConfirmation.toggle()
                    
                }.padding(.top, 12)
                    .fullScreenCover(isPresented: $navigateToConfirmation) {

                        CustomAlert(loading: $transferVM.loading) {
                            
                            VStack(spacing: 31) {
                                TextHelper(text: "Transfer Confirmation", colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                                
                                
                                TransferConfirmationCell(direction: NSLocalizedString("from", comment: ""),
                                                         bank: "Card Number",
                                                         name: card.cardHolder,
                                                         card: card.cardPan)
                                
                                TransferConfirmationCell(direction: NSLocalizedString("to", comment: ""),
                                                         bank: "Card Number",
                                                         name: selectedTransfer == nil ? cardHolder : selectedTransfer!.name,
                                                         card: selectedTransfer == nil ? receiverCardNumber : selectedTransfer!.card)
                                
                                HStack {
                                    TextHelper(text: "Total", colorResource: .darkBlueText, fontName: .bold, fontSize: 16)
                                    Spacer()
                                    TextHelper(text: "\(card.currency.rawValue.currencySymbol)\(transferVM.transferAmount)", colorResource: .darkBlueText, fontName: .bold, fontSize: 16)
                                }
                                
                            }
                            
                        } action: {
                            // start transaction
                            transferVM.startTransaction(card: card, recentTransfer: selectedTransfer, cardNumber: receiverCardNumber)
                        }
                    }
                
            }.padding(.horizontal, 24)
                .padding(.top, 40)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextHelper(text: NSLocalizedString("sendMoney", comment: ""), color: .black, fontName: .bold, fontSize: 20)
                    }
                    
                }
            }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: NotificationName.transferSuccess.rawValue))) { _ in
                router.pushHomePath(.transferSuccess(amount: transferVM.transferAmount,
                                                         currency: card.currency,
                                                         action: CustomAction(action: {
                    router.popToHomeRoot()

                })))
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $transferVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(transferVM.alertMessage)
            })
    }

}

struct TransferDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransferDetailView(card: PreviewModels.amexCard, selectedTransfer: nil, receiverCardNumber: "")
            .environmentObject(Router())
    }
}
