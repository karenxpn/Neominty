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
    
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            VStack( alignment: .leading, spacing: 12) {
                
                TextHelper(text: NSLocalizedString("verifyItsYou", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                TextHelper(text: "\(NSLocalizedString("weSentCode", comment: "")) \(phone).\n\(NSLocalizedString("enterItHere", comment: ""))", color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 16)

                OTPTextFieldView(pin: $authVM.OTP, authState: .notDetermind) { otp in
                    authVM.OTP = otp
                }.padding(.top, 20)
                
                HStack {
                    Spacer()
                    Button {
                        authVM.sendVerificationCode(send: false)
                        authVM.OTP = ""
                    } label: {
                        TextHelper(text: NSLocalizedString("resendCode", comment: ""), color: AppColors.green, fontName: Roboto.bold.rawValue, fontSize: 16)
                    }

                    Spacer()
                }.padding(.top, 20)
                
                Spacer()
                ButtonHelper(disabled: authVM.OTP.count != 6,
                             label: NSLocalizedString("confirm", comment: "")) {
                    authVM.checkVerificationCode()
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
            .alert(NSLocalizedString("error", comment: ""), isPresented: $authVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
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
