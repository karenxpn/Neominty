//
//  CardDetailTextFieldDecorator.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct CardDetailTextFieldDecorator<Content: View>: View {
    
    @Binding var isValid: Bool
    private var content: Content
    
    init( @ViewBuilder content: () -> Content, isValid: Binding<Bool>) {
        self.content = content()
        _isValid = isValid
    }
    
    var body: some View {
        content
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(!isValid ? Color.red : Color.clear, lineWidth: 1)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.superLightGray))
                    }
            }
    }
}
