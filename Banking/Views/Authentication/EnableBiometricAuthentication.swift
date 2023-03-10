//
//  EnableBiometricAuthentication.swift
//  Banking
//
//  Created by Karen Mirakyan on 11.03.23.
//

import SwiftUI

struct EnableBiometricAuthentication: View {
    var body: some View {
        ZStack {
            
            Image("biometric_background")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                
                Spacer()
                
                VStack(spacing: 12) {
                    TextHelper(text: NSLocalizedString("enableBiometric", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    TextHelper(text: NSLocalizedString("biometricAccessMessage", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 16)
                }
                
                Spacer()
                
                Image("biometric_fingerprint")
                
                Spacer()
                
                VStack( spacing: 24 ) {
                    ButtonHelper(disabled: false, label: NSLocalizedString("enableBiometric", comment: "")) {
                        
                    }
                    
                    Button {
                        
                    } label: {
                        TextHelper(text: NSLocalizedString("doItLater", comment: ""), color: AppColors.green, fontName: Roboto.bold.rawValue, fontSize: 16)
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
