//
//  ViewFailedToLoad.swift
//  Banking
//
//  Created by Karen Mirakyan on 18.05.23.
//

import SwiftUI

struct ViewFailedToLoad: View {
    
    let action: () -> ()
    
    var body: some View {
        VStack(spacing: 40) {
            
            Image("request-transfer-success")
            VStack(spacing: 12) {
                TextHelper(text: NSLocalizedString("sorryForInconvenience", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    .multilineTextAlignment(.center)

                TextHelper(text: NSLocalizedString("viewFiledToLoad", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 14)
                    .multilineTextAlignment(.center)
            }
            
            ButtonHelper(disabled: false, label: NSLocalizedString("reload", comment: "")) {
                action()
            }
            
        }.padding(24)
    }
}

struct ViewFailedToLoad_Previews: PreviewProvider {
    static var previews: some View {
        ViewFailedToLoad {
            
        }
    }
}
