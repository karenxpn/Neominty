//
//  IconGenerator.swift
//  Banking
//
//  Created by Karen Mirakyan on 23.06.25.
//

import SwiftUI

struct IconGenerator: View {
    let width: CGFloat
    let height: CGFloat
    let icon: String
    
    init(width: CGFloat = 48, height: CGFloat = 48, icon: String) {
        self.width = width
        self.height = height
        self.icon = icon
    }
    var body: some View {
        if #available(iOS 26.0, *) {
            Image(icon)
                .frame(width: width, height: height)
                .glassEffect(in: .rect(cornerRadius: 12.0))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.iconBackground))
                
                Image(icon)
            }.frame(width: width, height: height)
        }
    }
}

#Preview {
    IconGenerator(icon: "account-info")
}
