//
//  Notifications.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct Notifications: View {
    @StateObject private var notificationsVM = NotificationsViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            ForEach(notificationsVM.notifications, id: \.id) { notification in
                Text(notification.title)
            }
            
            if notificationsVM.loading {
                ProgressView()
            }
            
        }.padding(.top, 1)
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("notifications", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // mark all notifications as read
                    } label: {
                        Image("mark-read")
                    }

                }
                
            }.task {
                notificationsVM.getNotifications()
            }
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        Notifications()
    }
}
