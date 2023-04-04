//
//  AppDelegate.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
    @ObservedObject var notificationVM = PushNotificationViewModel()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
        
        let token = deviceToken
            .map{ String( format: "%02.2hhx", $0)}
            .joined()
        
        // store device token
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        
        let state = application.applicationState
        switch state {
        case .background:
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        default:
            break
        }
        
        if (firebaseAuth.canHandleNotification(userInfo)){
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }
    }
}
