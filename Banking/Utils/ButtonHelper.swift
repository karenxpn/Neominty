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
    var color: Color = Color(.darkBlue)
    var labelColor: Color = .white
    let action: (() -> Void)

    var body: some View {
        if #available(iOS 26.0, *) {
            Button(action: action) {
                HStack {
                    Spacer()
                    
                    Text( label )
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(labelColor)
                    
                    Spacer()
                }.frame(height: height)
            }.disabled(disabled)
                .glassEffect(.regular
                    .tint(color.opacity(disabled ? 0.5 : 1)).interactive(!disabled),
                             in: .capsule)

        } else {
            Button(action: action) {
                HStack {
                    Spacer()
                    
                    Text( label )
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(labelColor)
                    
                    Spacer()
                }.frame(height: height)
                .background(color)
                    .opacity(disabled ? 0.5 : 1)
                    .cornerRadius(16)
            }.disabled(disabled)
        }

    }
}

#Preview {
    ButtonHelper(disabled: false, label: "Continue") {
        
    }.padding()
}
