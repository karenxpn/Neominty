//
//  RequestTransferSuccess.swift
//  Banking
//
//  Created by Karen Mirakyan on 31.03.23.
//

import SwiftUI
import UniformTypeIdentifiers

struct RequestTransferSuccess: View {
    @EnvironmentObject var requestVM: RequestTransferViewModel
    @EnvironmentObject var router: Router
    var body: some View {
        
        VStack(spacing: 20) {
            Image("request-transfer-success")
            
            VStack(spacing: 12) {
                
                TextHelper(text: String(localized: .yourLinkIsReady), colorResource: .darkBlueText, fontName: .bold, fontSize: 24)
                
                TextHelper(text: requestVM.generatedLink, colorResource: .appGray, fontName: .bold, fontSize: 13)
                    .multilineTextAlignment(.center)
                
                ShareLink(item: requestVM.generatedLink) {
                    Label(String(localized: .shareLink), systemImage: "paperplane")
                        .accentColor(Color(.appGreen))
                }
            }
            
            ButtonHelper(disabled: false, label: String(localized: .backToHome)) {
                router.popToHomeRoot()
            }
        }.padding(58)
    }
}

struct RequestTransferSuccess_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransferSuccess()
            .environmentObject(RequestTransferViewModel())
    }
}
