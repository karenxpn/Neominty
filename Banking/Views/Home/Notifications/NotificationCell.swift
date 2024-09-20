//
//  NotificationCell.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.23.
//

import SwiftUI

struct NotificationCell: View {
    let notification: NotificationModelViewModel
    
    var body: some View {
        
        HStack(spacing: 16) {
            Image(notification.image)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    TextHelper(text: notification.title, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                    Spacer()
                    TextHelper(text: notification.createdAt,
                               color: AppColors.appGray,
                               fontName: notification.read ? Roboto.regular.rawValue : Roboto.bold.rawValue, fontSize: 12)
                }
                TextHelper(text: notification.body, color: AppColors.appGray,
                           fontName: notification.read ? Roboto.regular.rawValue : Roboto.bold.rawValue, fontSize: 12)
                    .lineLimit(2)
            }
            
            
        }.padding(4)
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell(notification: NotificationModelViewModel(model: PreviewModels.notifications[0]))
    }
}
