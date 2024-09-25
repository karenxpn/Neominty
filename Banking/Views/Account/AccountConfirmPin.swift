//
//  AccountConfirmPin.swift
//  Banking
//
//  Created by Karen Mirakyan on 03.04.23.
//

import SwiftUI

struct AccountConfirmPin: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack( alignment: .leading, spacing: 12) {
                    
                    TextHelper(text: NSLocalizedString("confirmYourNewPasscode", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 24)
                    
                    OTPTextFieldView(maxDigits: 5, pin: $authVM.passcodeConfirm, boxWidth: 56, boxHeight: 56, authState: .setPasscode) { otp in
                        
                    }.padding(.top, 80)
                    
                    Spacer()
                    ButtonHelper(disabled: authVM.passcode != authVM.passcodeConfirm,
                                 label: NSLocalizedString("confirm", comment: "")) {
                        authVM.storeChangedPin()
                        viewRouter.popToAccountRoot()
                    }.padding(.bottom, 30)
                }
                .frame(minHeight: geometry.size.height - 98)
                .padding(24)
            }.frame(width: geometry.size.width)
                .padding(.top, 1)
                .scrollDismissesKeyboard(.immediately)
        }.navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct AccountConfirmPin_Previews: PreviewProvider {
    static var previews: some View {
        AccountConfirmPin()
    }
}
