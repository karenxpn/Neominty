//
//  ButtonHelper.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI

struct ButtonHelper: View {
    
    var disabled: Bool
    var height: CGFloat = 56
    let label: String
    var color: Color = AppColors.darkBlue
    let action: (() -> Void)

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                Text( label )
                    .font(.custom("Roboto-Bold", size: 16))
                    .foregroundColor(.white)
                
                Spacer()
            }.frame(height: height)
            .background(color)
                .opacity(disabled ? 0.5 : 1)
                .cornerRadius(16)
        }.disabled(disabled)
    }
}
