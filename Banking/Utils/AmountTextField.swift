//
//  AmountTextField.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.04.23.
//

import SwiftUI

struct AmountTextField: View {
    @Binding var text: String
    @FocusState private var focused: Bool
    let fontSize: CGFloat
    
    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    
    var body: some View {
        TextField("1,000.00", text: $text)
            .keyboardType(.decimalPad)
            .font(.custom(Roboto.bold.rawValue, size: fontSize))
            .foregroundColor(focused ? AppColors.darkBlue : Color.clear)
            .padding(.leading, 5)
            .onChange(of: text, perform: { newValue in
                text = newValue.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
            }).focused($focused)
            .overlay(alignment: .leading, content: {
                if !focused {
                    Button(action: {
                        focused = true
                    }, label: {
                        TextHelper(text: formatText(text: text), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: fontSize)
                            .lineLimit(1)
                    })
                }
            })
    }
    
    
    private func formatText(text: String) -> String {
        guard let number = Double(text.replacingOccurrences(of: ",", with: "")) else {
            return ""
        }
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

struct AmountTextField_Previews: PreviewProvider {
    static var previews: some View {
        AmountTextField(text: .constant("123.23"), fontSize: 24)
    }
}


extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
