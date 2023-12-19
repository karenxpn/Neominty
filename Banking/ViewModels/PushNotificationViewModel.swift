//
//  PushNotificationViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import Foundation
import UserNotifications
import SwiftUI

@MainActor
class PushNotificationViewModel: ObservableObject {
    @Published var deviceToken: String = ""
    @Published private(set) var hasPermission = false
    
    
    init() {
        Task {
            await checkPermission()
        }
    }
    func requestPermission() async {
        do {
            self.hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print(error)
        }
    }
    
    func checkPermission() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized,
                .provisional,
                .ephemeral:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
}
