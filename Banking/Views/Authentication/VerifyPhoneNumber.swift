//
//  VerifyPhoneNumber.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

struct VerifyPhoneNumber: View {
    @EnvironmentObject var authVM: AuthViewModel
    let phone: String
    var auth: Bool = true
    
    
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            VStack( alignment: .leading, spacing: 12) {
                
                TextHelper(text: String(localized: .verifyItsYou), colorResource: .darkBlueText, fontName: .bold, fontSize: 24)
                TextHelper(text: "\(String(localized: .weSentCode)) \(phone).\n\(String(localized: .enterItHere))", colorResource: .appGray, fontSize: 16)

                OTPTextFieldView(pin: $authVM.OTP, authState: .notDetermind) { otp in
                    authVM.OTP = otp
                }.padding(.top, 20)
                
                HStack {
                    Spacer()
                    Button {
                        authVM.sendVerificationCode(send: false)
                        authVM.OTP = ""
                    } label: {
                        TextHelper(text: String(localized: .resendCode), colorResource: .appGreen, fontName: .bold, fontSize: 16)
                    }

                    Spacer()
                }.padding(.top, 20)
                
                Spacer()
                ButtonHelper(disabled: authVM.OTP.count != 6,
                             label: String(localized: .confirm)) {
                    authVM.checkVerificationCode(auth: auth)
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
            .padding(.bottom, UIScreen.main.bounds.height * 0.08)
            .alert(String(localized: .error), isPresented: $authVM.showAlert, actions: {
                Button(String(localized: .gotIt), role: .cancel) { }
            }, message: {
                Text(authVM.alertMessage)
            })
    }
}


struct VerifyPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        VerifyPhoneNumber(phone: "+37493936313")
            .environmentObject(AuthViewModel())
    }
}
