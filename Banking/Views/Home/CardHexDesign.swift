//
//  CardHexDesign.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct CardHexDesign: View {
    var foreground: Color = .white
    
    var body: some View {
        VStack(spacing: 0) {
            Image("card-hex-sign")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(foreground)
                .frame(width: UIScreen.main.bounds.width * 0.3)
            
            Image("card-hex-sign")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(foreground)
                .frame(width: UIScreen.main.bounds.width * 0.3)
        }
    }
}

struct CardHexDesign_Previews: PreviewProvider {
    static var previews: some View {
        CardHexDesign(foreground: .black)
    }
}
