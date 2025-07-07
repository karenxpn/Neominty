//
//  GeneralSettings.swift
//  Banking
//
//  Created by Karen Mirakyan on 03.04.23.
//

import SwiftUI

struct GeneralSettings: View {
    @AppStorage("userID") var userID: String = ""
    @AppStorage("biometricEnabled") var biometricEnabled: Bool = false
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var accountVM = AccountViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 27) {
                    
                        GeneralSettingsCell(title: String(localized: .pushNotifications),
                                            message: String(localized: .pushNotificationsMessage), toggler: $accountVM.receiveNotifications) { value in
                            accountVM.updateNotificationPreference(receive: value)
                        }.disabled(accountVM.loading)
                        .overlay {
                            if accountVM.loading {
                                ProgressView()
                            }
                        }
                        
                        GeneralSettingsCell(title: String(localized: .faceId),
                                            message: String(localized: .faceIdMessage), toggler: $biometricEnabled) { value in
                            biometricEnabled = value
                        }
                        
                        GeneralSettingsCell(title: String(localized: .email),
                                            message: String(localized: .emailMessage), toggler: $accountVM.receiveEmails) { value in
                            accountVM.updateEmailPreference(receive: value)
                        }.disabled(accountVM.loading)
                        .overlay {
                            if accountVM.loading {
                                ProgressView()
                            }
                        }
                    
                    Spacer()
                    
                    ButtonHelper(disabled: false, label: String(localized: .logout), color: Color(.appGreen)) {
                        authVM.signOut()
                    }.padding(.bottom, UIScreen.main.bounds.height * 0.15)
                    
                }
                .frame(minHeight: geometry.size.height)
                .padding(24)
            }.frame(width: geometry.size.width)
                .padding(.top, 1)
        }.navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if !userID.isEmpty {
                    accountVM.getPreferences()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: String(localized: .generalSettings), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                }
            }
    }
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
