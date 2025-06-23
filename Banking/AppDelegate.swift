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
import FirebaseAppCheck
import FirebaseMessaging


class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject, MessagingDelegate {
    @ObservedObject var notificationVM = PushNotificationViewModel()
    var app: BankingApp?
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🌐 Firebase registration token: \(String(describing: fcmToken))")
        // You can send this token to your backend server if needed
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
        
        let _ = deviceToken
            .map{ String( format: "%02.2hhx", $0)}
            .joined()
        
        // store device token
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        
        let state = application.applicationState
        switch state {
        case .background:
            UNUserNotificationCenter.current().setBadgeCount(+1) { error in
                print(error as Any)
            }
        default:
            UNUserNotificationCenter.current().setBadgeCount(0)
            break
        }
        
        if (firebaseAuth.canHandleNotification(userInfo)){
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let deeplink = response.notification.request.content.userInfo["link"] as? String, let url = URL(string: deeplink) {
            app?.handleDeeplink(from: url)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .badge, .banner, .list]
    }
}
