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
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        
        VStack(spacing: 20) {
            Image("request-transfer-success")
            
            VStack(spacing: 12) {
                
                TextHelper(text: NSLocalizedString("yourLinkIsReady", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 24)
                
                TextHelper(text: requestVM.generatedLink, colorResource: .appGray, fontName: .bold, fontSize: 13)
                    .multilineTextAlignment(.center)
                
                ShareLink(item: requestVM.generatedLink) {
                    Label(NSLocalizedString("shareLink", comment: ""), systemImage: "paperplane")
                        .accentColor(Color(.appGreen))
                }
            }
            
            ButtonHelper(disabled: false, label: NSLocalizedString("backToHome", comment: "")) {
                viewRouter.popToHomeRoot()
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
