//
//  AccountCreatePin.swift
//  Banking
//
//  Created by Karen Mirakyan on 03.04.23.
//

import SwiftUI

struct AccountCreatePin: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var navigateToConfirm: Bool = false
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack( alignment: .leading, spacing: 12) {
                    
                    TextHelper(text: NSLocalizedString("setNewPasscode", comment: ""), colorResource: .darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    
                    OTPTextFieldView(maxDigits: 5, pin: $authVM.passcode, boxWidth: 56, boxHeight: 56, authState: .setPasscode) { otp in
                        
                    }.padding(.top, 80)
                    
                    Spacer()
                    ButtonHelper(disabled: authVM.passcode.count != 5,
                                 label: NSLocalizedString("next", comment: "")) {
                        authVM.passcodeConfirm = ""
                        navigateToConfirm.toggle()
                    }.navigationDestination(isPresented: $navigateToConfirm) {
                        AccountConfirmPin()
                            .environmentObject(authVM)
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

struct AccountCreatePin_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreatePin()
    }
}
