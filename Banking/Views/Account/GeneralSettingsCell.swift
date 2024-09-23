//
//  GeneralSettingsCell.swift
//  Banking
//
//  Created by Karen Mirakyan on 03.04.23.
//

import SwiftUI

struct GeneralSettingsCell: View {
    let title: String
    let message: String
    @Binding var toggler: Bool
    
    let action: (Bool) -> ()
    
    var body: some View {
        Toggle(isOn: $toggler) {
            VStack(alignment: .leading, spacing: 4) {
                TextHelper(text: title, color: Color(.darkBlue), fontName: Roboto.medium.rawValue, fontSize: 14)
                TextHelper(text: message, color: Color(.appGray), fontName: Roboto.regular.rawValue, fontSize: 12)
            }
        }.toggleStyle(SwitchToggleStyle(tint: Color(.appGreen)))
            .onChange(of: toggler) { newValue in
                action(newValue)
            }

    }
}

struct GeneralSettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsCell(title: NSLocalizedString("pushNotifications", comment: ""), message: NSLocalizedString("pushNotificationsMessage", comment: ""), toggler: .constant(true)) { toggler in
            
        }
    }
}
