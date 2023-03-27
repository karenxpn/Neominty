//
//  AddNewCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct AddNewCard: View {
    
    @State private var cardNumber: String = ""
    @State private var cardHolder: String = ""
    @State private var cvv: String = ""
    @State private var expirationDate: String = ""
    
    @State private var cardHolderValid: Bool = false
    @State private var cardNumberValid: Bool = false
    @State private var cvvValid: Bool = false
    @State private var expireDateValid: Bool = false
    
    @State private var cardType = CardBankType.nonIdentified
    
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack( alignment: .leading, spacing: 16) {
                TextHelper(text: NSLocalizedString("cardDetails", comment: ""),
                           color: AppColors.darkBlue,
                           fontName: Roboto.bold.rawValue,
                           fontSize: 18)
                
                
                CardDetailTextFieldDecorator(content: {
                    HStack {
                        Image("card-placeholder")
                        
                        CardValidationTF(text: $cardNumber,
                                         isValid: $cardNumberValid,
                                         bankCardType: $cardType,
                                         tfType: .cardNumber,
                                         tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                         subtitle: NSLocalizedString("cardNumber", comment: ""))
                    }
                }, isValid: $cardNumberValid)
                

                
                HStack(spacing: 12) {
                    CardDetailTextFieldDecorator(content: {
                        CardValidationTF(text: $expirationDate,
                                         isValid: $expireDateValid,
                                         bankCardType: $cardType,
                                         tfType: .dateExpiration,
                                         tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                         subtitle: NSLocalizedString("expireDate", comment: ""))
                    }, isValid: $expireDateValid)
                    

                    CardDetailTextFieldDecorator(content: {
                        CardValidationTF(text: $cvv,
                                         isValid: $cvvValid,
                                         bankCardType: $cardType,
                                         tfType: .cvv,
                                         tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                         subtitle: NSLocalizedString("CVV", comment: ""))
                    }, isValid: $cvvValid)
                }
                
                CardDetailTextFieldDecorator(content: {
                    CardValidationTF(text: $cardHolder,
                                     isValid: $cardHolderValid,
                                     bankCardType: $cardType,
                                     tfType: .cardHolder,
                                     tfFont: .custom(Roboto.regular.rawValue, size: 16),
                                     subtitle: NSLocalizedString("cardHolder", comment: ""))
                }, isValid: $cardHolderValid)

            }.padding(24)
            
        }.navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("newCard", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }
    }
}

struct AddNewCard_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCard()
    }
}
