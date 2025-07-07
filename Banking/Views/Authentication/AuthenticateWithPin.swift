//
//  AuthenticateWithPin.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import SwiftUI

struct AuthenticateWithPin: View {
    @AppStorage("biometricEnabled") var biometricEnabled: Bool = false
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            VStack( alignment: .leading, spacing: 12) {
                
                TextHelper(text: String(localized: .enterYourPasscode), colorResource: .darkBlueText, fontName: .bold, fontSize: 24)

                OTPTextFieldView(maxDigits: 5, pin: $authVM.passcodeConfirm, boxWidth: 56, boxHeight: 56, authState: .enterPasscode) { otp in
                    
                }.padding(.top, 80)
                
                Button {
                    authVM.sendVerificationCode()
                    biometricEnabled = false
                } label: {
                    TextHelper(text: String(localized: .forgotPasscode), colorResource: .appGreen, fontName: .bold, fontSize: 16)
                }.padding(.top, 12)


                Spacer()
                ButtonHelper(disabled: authVM.passcodeConfirm.count != 5,
                             label: String(localized: .confirm)) {
                    authVM.checkPin()
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
            ).alert(String(localized: .error), isPresented: $authVM.showAlert, actions: {
                Button(String(localized: .gotIt), role: .cancel) { }
            }, message: {
                Text(authVM.alertMessage)
            })
    }
}

struct AuthenticateWithPin_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticateWithPin()
    }
}
