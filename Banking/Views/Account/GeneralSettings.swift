//
//  GeneralSettings.swift
//  Banking
//
//  Created by Karen Mirakyan on 03.04.23.
//

import SwiftUI

struct GeneralSettings: View {
    // notifications view model
    @State private var notifications: Bool = false
    @State private var emails: Bool = false
    @AppStorage("biometricEnabled") var biometricEnabled: Bool = false
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var notificationVM = PushNotificationViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 27) {
                    
                        GeneralSettingsCell(title: NSLocalizedString("pushNotifications", comment: ""),
                                            message: NSLocalizedString("pushNotificationsMessage", comment: ""), toggler: $notifications) { value in
//                            print(value)
//                            if value == true {
//                                notificationVM.turnOnNotifications()
//                            } else {
//                                notificationVM.turnOffNotifications()
//                            }
//
//                            notificationVM.checkPermissionStatus { status in
//                                if status == .authorized {
//                                    print("authorized")
//                                } else  {
//                                    print("not authorized")
//                                }
//                            }
                        }
                        
                        GeneralSettingsCell(title: NSLocalizedString("faceId", comment: ""),
                                            message: NSLocalizedString("faceIdMessage", comment: ""), toggler: $biometricEnabled) { value in
                            
                        }
                        
                        GeneralSettingsCell(title: NSLocalizedString("email", comment: ""),
                                            message: NSLocalizedString("emailMessage", comment: ""), toggler: $emails) { value in
                            
                        }
                    
                    Spacer()
                    
                    ButtonHelper(disabled: false, label: NSLocalizedString("logout", comment: ""), color: AppColors.green) {
                        authVM.signOut()
                    }.padding(.bottom, UIScreen.main.bounds.height * 0.15)
                    
                }
                .frame(minHeight: geometry.size.height)
                .padding(24)
            }.frame(width: geometry.size.width)
                .padding(.top, 1)
        }.navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                notificationVM.checkPermissionStatus { status in
                    if status == .authorized {
                        self.notifications = true
                    } else {
                        self.notifications = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("generalSettings", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }
    }
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
