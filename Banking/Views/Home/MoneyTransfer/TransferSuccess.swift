//
//  TransferSuccess.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI

struct TransferSuccess: View {
    @EnvironmentObject var viewRouter: ViewRouter
    let amount: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                Image("transfer-success")
                
                VStack(spacing: 12) {
                    TextHelper(text: NSLocalizedString("successfulTransfer", comment: ""), color: AppColors.darkBlue,
                               fontName: Roboto.bold.rawValue, fontSize: 24)
                    .padding(.horizontal, 36)
                    .multilineTextAlignment(.center)
                    
                    TextHelper(text: NSLocalizedString("transfersAreReviewed", comment: ""),
                               color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 11)
                    .padding(.horizontal, 36)
                    .multilineTextAlignment(.center)
                }
                
                TextHelper(text: "$ \(amount)", color: AppColors.darkBlue,
                           fontName: Roboto.bold.rawValue, fontSize: 31)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.lightGray)
                }
                
                ButtonHelper(disabled: false, label: NSLocalizedString("backToHome", comment: "")) {
                    viewRouter.popToHomeRoot()
                }
            }.padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.padding(.top, 1)
        
    }
}

struct TransferSuccess_Previews: PreviewProvider {
    static var previews: some View {
        TransferSuccess(amount: "123,3")
            .environmentObject(ViewRouter())
    }
}
