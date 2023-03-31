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
                
                if requestVM.requestType == .link {
                    TextHelper(text: NSLocalizedString("yourLinkIsReady", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    
                    Button {
                        UIPasteboard.general.setValue(requestVM.generatedLink,
                                    forPasteboardType: UTType.plainText.identifier)
                    } label: {
                        TextHelper(text: requestVM.generatedLink, color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 13)
                    }
                    
                    TextHelper(text: NSLocalizedString("clickToCopy", comment: ""), color: AppColors.gray, fontName: Roboto.light.rawValue, fontSize: 11)

                } else {
                    TextHelper(text: NSLocalizedString("requestIsSent", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    
                    if requestVM.requestType == .phone {
                        TextHelper(text: NSLocalizedString("yourRequestForReceivingMoneyIsSentTo", comment: "") + " +\(requestVM.code)\(requestVM.phoneNumber)",
                                   color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 11)
                        .multilineTextAlignment(.center)
                    } else {
                        TextHelper(text: NSLocalizedString("yourRequestForReceivingMoneyIsSentTo", comment: "") + " " + requestVM.email,
                                   color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 11)
                        .multilineTextAlignment(.center)
                    }
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
