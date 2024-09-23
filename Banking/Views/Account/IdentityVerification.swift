//
//  IdentityVerification.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.10.23.
//

import SwiftUI

struct IdentityVerification: View {
    
    @StateObject private var identityVM = IdentityVerificationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                TextHelper(text: NSLocalizedString("letsVerifyIdentity", comment: ""), colorResource: .darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                TextHelper(text: NSLocalizedString("weAreRequiredByLaw", comment: ""), colorResource: .appGray, fontName: Roboto.regular.rawValue, fontSize: 16)
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding([.horizontal, .top], 24)
            
            Image("identity-verification")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 237, height: 281)
                .padding(.top, 72)
                
            ButtonHelper(disabled: false,
                         label: NSLocalizedString("verifyIdentity", comment: "")) {
                
                identityVM.initializeSDK()
                
            }.padding(.horizontal, 24)
                .padding(.top, 138)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
            
        }.padding(.top, 1)
    }
}

struct IdentityVerification_Previews: PreviewProvider {
    static var previews: some View {
        IdentityVerification()
    }
}
