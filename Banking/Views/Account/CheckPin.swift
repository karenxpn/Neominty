//
//  CheckPin.swift
//  Banking
//
//  Created by Karen Mirakyan on 03.04.23.
//

import SwiftUI

struct CheckPin: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @StateObject private var authVM = AuthViewModel()
    @State private var navigate: Bool = false
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack( alignment: .leading, spacing: 12) {
                    
                    TextHelper(text: NSLocalizedString("enterYourPasscode", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    
                    OTPTextFieldView(maxDigits: 5, pin: $authVM.passcodeConfirm, boxWidth: 56, boxHeight: 56, authState: .setPasscode) { otp in
                        
                    }.padding(.top, 80)
                    
                    
                    Spacer()
                    
                    ButtonHelper(disabled: authVM.passcodeConfirm.count != 5,
                                 label: NSLocalizedString("confirm", comment: "")) {
                        if authVM.checkPinToPass() {
                            navigate.toggle()
                        }
                    }.padding(.bottom, 30)
                        .navigationDestination(isPresented: $navigate) {
                            AccountCreatePin()
                                .environmentObject(authVM)
                        }
                    
                }
                .frame(minHeight: geometry.size.height - 98)
                .padding(24)
            }.frame(width: geometry.size.width)
                .padding(.top, 1)
                .scrollDismissesKeyboard(.immediately)
        }.navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .alert(NSLocalizedString("error", comment: ""), isPresented: $authVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(authVM.alertMessage)
            })
    }
}

struct CheckPin_Previews: PreviewProvider {
    static var previews: some View {
        CheckPin()
    }
}
