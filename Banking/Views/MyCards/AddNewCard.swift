//
//  AddNewCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct AddNewCard: View {
    
    @StateObject private var cardsVM = CardsViewModel()
    
    @State private var cardHolderValid: Bool = false
    @State private var cardNumberValid: Bool = false
    @State private var cvvValid: Bool = false
    @State private var expireDateValid: Bool = false
    
    let designs: [CardDesign] = [.blue, .blueGreen, .green, .greenBlue]
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 16)  {
                ZStack( alignment: .trailing) {
                    CardStyling(cardNumber: $cardsVM.cardNumber,
                                cardType: $cardsVM.cardType,
                                cardHolder: $cardsVM.cardHolder,
                                expireDate: $cardsVM.expirationDate,
                                cardDesign: $cardsVM.design)
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 16) {
                        ForEach(designs, id: \.id) { design in
                            CardStylingSelector(selectedItem: $cardsVM.design, cardDesign: design)
                        }
                    }.padding(.vertical, 15)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                }.padding(.top, 34)

                
                VStack( alignment: .leading, spacing: 16) {
                    
                    
                    TextHelper(text: NSLocalizedString("cardDetails", comment: ""),
                               color: AppColors.darkBlue,
                               fontName: Roboto.bold.rawValue,
                               fontSize: 18)
                    
                    
                    CardDetailTextFieldDecorator(content: {
                        HStack {
                            Image("card-placeholder")
                            
                            CardValidationTF(text: $cardsVM.cardNumber,
                                             isValid: $cardNumberValid,
                                             bankCardType: $cardsVM.cardType,
                                             tfType: .cardNumber,
                                             tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                             subtitle: NSLocalizedString("cardNumber", comment: ""))
                        }
                    }, isValid: $cardNumberValid)
                    
                    
                    
                    HStack(spacing: 12) {
                        CardDetailTextFieldDecorator(content: {
                            CardValidationTF(text: $cardsVM.expirationDate,
                                             isValid: $expireDateValid,
                                             bankCardType: $cardsVM.cardType,
                                             tfType: .dateExpiration,
                                             tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                             subtitle: NSLocalizedString("expireDate", comment: ""))
                        }, isValid: $expireDateValid)
                        
                        
                        CardDetailTextFieldDecorator(content: {
                            CardValidationTF(text: $cardsVM.cvv,
                                             isValid: $cvvValid,
                                             bankCardType: $cardsVM.cardType,
                                             tfType: .cvv,
                                             tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                             subtitle: NSLocalizedString("CVV", comment: ""))
                        }, isValid: $cvvValid)
                    }
                    
                    CardDetailTextFieldDecorator(content: {
                        CardValidationTF(text: $cardsVM.cardHolder,
                                         isValid: $cardHolderValid,
                                         bankCardType: $cardsVM.cardType,
                                         tfType: .cardHolder,
                                         tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                         subtitle: NSLocalizedString("cardHolder", comment: ""))
                    }, isValid: $cardHolderValid)
                    
                    
                    Spacer()
                    
                    ButtonHelper(disabled: !cardHolderValid || !cardNumberValid || !cvvValid || !expireDateValid || cardsVM.loading, label: NSLocalizedString("save", comment: "")) {
                        cardsVM.attachCard()
                    }.fullScreenCover(isPresented: $showAlert) {
                        CongratulationAlert {
                            VStack(spacing: 12) {
                                TextHelper(text: NSLocalizedString("cardIsReady", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                                
                                TextHelper(text: NSLocalizedString("cardIsReadyMessage", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                                
                            }
                        }
                    }
                    
                }.padding(24)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            }
            
        }.navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("newCard", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "cardAttached"))) { _ in
                showAlert.toggle()
            }
    }
}

struct AddNewCard_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCard()
    }
}
