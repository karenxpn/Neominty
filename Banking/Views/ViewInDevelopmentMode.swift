//
//  ViewInDevelopmentMode.swift
//  Banking
//
//  Created by Karen Mirakyan on 31.03.23.
//

import SwiftUI
import SSSwiftUIGIFView

struct ViewInDevelopmentMode: View {
    var body: some View {
        
        LazyVStack(spacing: 40) {
            
            GifImageView("coins-hover")
                .frame(width: 200, height: 200)
            
//        Image("view-in-development")
//            .frame(height: 200)

            VStack(spacing: 12) {
                TextHelper(text: String(localized: .sorryForInconvenience), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                    .multilineTextAlignment(.center)

                TextHelper(text: String(localized: .thisPageIsInDevelopmentMode), colorResource: .appGray, fontSize: 14)
                    .multilineTextAlignment(.center)
            }
            
        }.padding(24)
    }
}

struct ViewInDevelopmentMode_Previews: PreviewProvider {
    static var previews: some View {
        ViewInDevelopmentMode()
    }
}
