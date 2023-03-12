//
//  CreatePin.swift
//  Banking
//
//  Created by Karen Mirakyan on 11.03.23.
//

import SwiftUI

struct CreatePin: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        VStack( alignment: .leading, spacing: 12) {
            
            TextHelper(text: NSLocalizedString("setNewPasscode", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)

            OTPTextFieldView(maxDigits: 5, pin: $authVM.passcode, boxWidth: 56, boxHeight: 56) { otp in
                
            }.padding(.top, 80)

            Spacer()
            ButtonHelper(disabled: authVM.passcode.count != 5,
                         label: NSLocalizedString("next", comment: "")) {
                authVM.path.append(ViewPaths.confirmPasscode.rawValue)
            }
        }.ignoresSafeArea(.keyboard, edges: .bottom)
            .padding(24)
            .navigationTitle(Text(""))
    }
}

struct CreatePin_Previews: PreviewProvider {
    static var previews: some View {
        CreatePin()
            .environmentObject(AuthViewModel())
    }
}
