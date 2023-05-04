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
            
            LazyVStack(spacing: 16) {
                ForEach(notificationsVM.notifications, id: \.id) { notification in
                    NotificationCell(notification: notification)
                        .onAppear {
                            if notification.id == notificationsVM.notifications.last?.id && !notificationsVM.loading {
                                notificationsVM.getNotifications()
                            }
                        }
                }
            }.padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
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
                
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $notificationsVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(notificationsVM.alertMessage)
            }).task {
                notificationsVM.getNotifications()
            }
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        Notifications()
    }
}
