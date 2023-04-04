//
//  PushNotificationViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import Foundation
import UserNotifications
import SwiftUI

class PushNotificationViewModel: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    @Published var deviceToken: String = ""
    
    func requestPermission() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current()
            .requestAuthorization(options: options) { (granted, error) in
            
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func checkPermissionStatus(completion: @escaping(UNAuthorizationStatus) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            DispatchQueue.main.async {
                completion(permission.authorizationStatus)
            }
        }
    }
    
    func turnOnNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func turnOffNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
}
