//
//  OTPTextFieldView.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

struct OTPTextFieldView: View {
    
    var maxDigits: Int = 6
    @Binding var pin: String
    @FocusState var focus: Int?
    var boxWidth: CGFloat = 45
    var boxHeight: CGFloat = 45

    var handler: (String) -> Void
    
    var body: some View {
        ZStack {
            pinDots
            backgroundField
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                focus = 0
            }
        }
    }
    
    private var pinDots: some View {
        HStack(spacing: 12) {
            ForEach(0..<maxDigits, id: \.self) { index in
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(focus == index ? .black : .clear, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.superLightGray))
                        .frame(width: boxWidth, height: boxHeight)
                    
                    TextHelper(text: self.getDigits(at: index), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                }
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
            
        })
        
        return TextField("", text: boundPin)
            .focused($focus, equals: pin.count)
            .keyboardType(.numberPad)
            .foregroundColor(.clear)
            .accentColor(.clear)
    }
    
    
    private func submitPin() {
        guard !pin.isEmpty else {
            return
        }
        
        if pin.count == maxDigits {
            handler(pin)
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getDigits(at index: Int) -> String {
        if index >= self.pin.count {
            return ""
        }
        
        return self.pin.digits[index].numberString
    }
}


struct OTPTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextFieldView(pin: .constant("")) { otp in }
    }
}
