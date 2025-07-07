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
                TextHelper(text: String(localized: .sorryForInconvenience), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                    .multilineTextAlignment(.center)

                TextHelper(text: String(localized: .viewFiledToLoad), colorResource: .appGray, fontSize: 14)
                    .multilineTextAlignment(.center)
            }
            
            ButtonHelper(disabled: false, label: String(localized: .reload)) {
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
