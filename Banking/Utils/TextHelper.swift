//
//  TextHelper.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

struct TextHelper: View {
    let text: String
    let color: Color
    let fontName: Roboto
    let fontSize: CGFloat
    let font: Font
    
    // Accept a `Color?` for SwiftUI colors or `ColorResource?` for custom colors
    init(text: String, color: Color? = nil, colorResource: ColorResource? = nil, fontName: Roboto = .regular, fontSize: CGFloat = 12) {
        self.text = text
        
        // Prioritize the provided `Color`, then use `ColorResource` if provided, otherwise default to `.black`
        if let color = color {
            self.color = color
        } else if let colorResource = colorResource {
            self.color = Color(colorResource)
        } else {
            self.color = .black
        }
        
        self.fontName = fontName
        self.fontSize = fontSize
        self.font = .custom(fontName.rawValue, size: fontSize)
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(font)
            .fixedSize(horizontal: false, vertical: true)
            .kerning(0.3)
    }
}

struct TextHelper_Previews: PreviewProvider {
    static var previews: some View {
        TextHelper(text: "some text", color: .white) // Use SwiftUI Color
        TextHelper(text: "some text", colorResource: .appGray) // Use ColorResource
    }
}
