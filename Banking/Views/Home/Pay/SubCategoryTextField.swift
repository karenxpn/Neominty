//
//  SubCategoryTextField.swift
//  Banking
//
//  Created by Karen Mirakyan on 17.04.23.
//

import SwiftUI

struct SubCategoryTextField: View {
    @FocusState private var focused: Bool
    @State private var text: String = ""
    let field: SubcategoryField
    @Binding var fields: [String: String]
    @Binding var validation: [String: Bool]
    
    var body: some View {
        TextField(fields[field.name] == nil || ((fields[field.name]?.isEmpty) != nil) ? field.placeholder : fields[field.name]!, text: $text)
            .keyboardType( field.keyboardType == .keyboard ? .default : (field.keyboardType == .phone ? .phonePad : .numberPad))
            .font(.custom(Roboto.regular.rawValue, size: 16))
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(validation[field.name] == false ? Color.red : Color.clear, lineWidth: 1)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.superLightGray)
                    }
            }
            .padding(.top, 16)
            .focused($focused)
            .onChange(of: focused) { newValue in
                if newValue {
                    text = fields[field.name] ?? ""
                } else {
                    fields[field.name] = text
                    validation[field.name] = NSPredicate(format:"SELF MATCHES %@", field.regex).evaluate(with: text)

                }
            }.onChange(of: text) { newValue in
            }
    }
}

struct SubCategoryTextField_Previews: PreviewProvider {
    static var previews: some View {
        SubCategoryTextField(field: SubcategoryField(id: UUID().uuidString, placeholder: "Phone Number", regex: "^[0-9]{6,}$", name: "phoneNumber", keyboardType: .numbers), fields: .constant([:]), validation: .constant([:]))
    }
}
