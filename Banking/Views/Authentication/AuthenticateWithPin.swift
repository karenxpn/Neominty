//
//  AuthenticateWithPin.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import SwiftUI

struct AuthenticateWithPin: View {
    @EnvironmentObject var authVM: AuthViewModel
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            VStack( alignment: .leading, spacing: 12) {
                
                TextHelper(text: NSLocalizedString("enterYourPasscode", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)

                OTPTextFieldView(maxDigits: 5, pin: $authVM.passcodeConfirm, boxWidth: 56, boxHeight: 56, authState: .enterPasscode) { otp in
                    
                }.padding(.top, 80)

                Spacer()
                ButtonHelper(disabled: authVM.passcodeToBeMatched != authVM.passcodeConfirm ||
                             authVM.passcodeToBeMatched.isEmpty,
                             label: NSLocalizedString("confirm", comment: "")) {
                    authVM.authState = .authenticated
                }
            }.ignoresSafeArea(.keyboard, edges: .bottom)
                .padding(24)
        }.navigationBarTitle("", displayMode: .inline)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
    }
}

struct AuthenticateWithPin_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticateWithPin()
    }
}
