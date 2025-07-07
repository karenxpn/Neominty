//
//  EnableBiometricAuthentication.swift
//  Banking
//
//  Created by Karen Mirakyan on 11.03.23.
//

import SwiftUI

struct EnableBiometricAuthentication: View {
    @AppStorage("biometricEnabled") var biometricEnabled: Bool = false
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            
            Image("biometric_background")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                
                Spacer()
                
                VStack(spacing: 12) {
                    TextHelper(text: String(localized: .enableBiometric), colorResource: .darkBlueText, fontName: .bold, fontSize: 24)
                    TextHelper(text: String(localized: .biometricAccessMessage), colorResource: .appGray, fontSize: 16)
                }
                
                Spacer()
                
                Image("biometric_fingerprint")
                
                Spacer()
                
                VStack( spacing: 24 ) {
                    ButtonHelper(disabled: false, label: String(localized: .enableBiometric)) {
                        authVM.biometricAuthentication()
                    }
                    
                    Button {
                        biometricEnabled = false
                        authVM.path = []
                    } label: {
                        TextHelper(text: String(localized: .doItLater), colorResource: .appGreen, fontName: .bold, fontSize: 16)
                    }
                }

                
            }.padding(33)
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct EnableBiometricAuthentication_Previews: PreviewProvider {
    static var previews: some View {
        EnableBiometricAuthentication()
    }
}
