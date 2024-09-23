//
//  TransferSuccess.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI

struct TransferSuccess: View {
    let amount: String
    let currency: CardCurrency
    let action: () -> ()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                Image("transfer-success")
                
                VStack(spacing: 12) {
                    TextHelper(text: NSLocalizedString("successfulTransfer", comment: ""), colorResource: .darkBlue,
                               fontName: Roboto.bold.rawValue, fontSize: 24)
                    .padding(.horizontal, 36)
                    .multilineTextAlignment(.center)
                    
                    TextHelper(text: NSLocalizedString("transfersAreReviewed", comment: ""),
                               colorResource: .appGray, fontName: Roboto.regular.rawValue, fontSize: 11)
                    .padding(.horizontal, 36)
                    .multilineTextAlignment(.center)
                }
                
                TextHelper(text: "\(currency.rawValue.currencySymbol) \(amount)", colorResource: .darkBlue,
                           fontName: Roboto.bold.rawValue, fontSize: 31)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.lightGray))
                }
                
                ButtonHelper(disabled: false, label: NSLocalizedString("backToHome", comment: "")) {
                    action()
                }
            }.padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.padding(.top, 1)
        
    }
}

struct TransferSuccess_Previews: PreviewProvider {
    static var previews: some View {
        TransferSuccess(amount: "123,3", currency: .amd) {
            
        }
            .environmentObject(ViewRouter())
    }
}
