//
//  AccountListButton.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import SwiftUI

struct AccountListButton: View {
    let icon: String
    let label: String
    let action: () -> ()
    var body: some View {
        
        Button {
            action()
        } label: {
            HStack(spacing: 16) {
                Image(icon)
                TextHelper(text: label, color: Color(.darkBlue), fontName: Roboto.medium.rawValue, fontSize: 14)
                
                Spacer()
                
                Image("chevron-right")
            }
        }
    }
}

struct AccountListButton_Previews: PreviewProvider {
    static var previews: some View {
        AccountListButton(icon: "settings", label: NSLocalizedString("generalSettings", comment: ""), action: {
            
        })
    }
}
