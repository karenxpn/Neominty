//
//  TextHelper.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

import SwiftUI

struct TextHelper: View {
    let text: String
    let color: Color
    let fontName: String
    let fontSize: CGFloat
    let font: Font
    
    init(text: String, color: Color = .black, fontName: String = Roboto.regular.rawValue, fontSize: CGFloat = 12) {
        self.text = text
        self.color = color
        self.fontName = fontName
        self.fontSize =  fontSize
        self.font = .custom(fontName, size: fontSize)
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(font)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct TextHelper_Previews: PreviewProvider {
    static var previews: some View {
        TextHelper(text: "some text")
    }
}
