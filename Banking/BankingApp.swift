//
//  BankingApp.swift
//  Banking
//
//  Created by Karen Mirakyan on 09.03.23.
//

import SwiftUI

@main
struct BankingApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
