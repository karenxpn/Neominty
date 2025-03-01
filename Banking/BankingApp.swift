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
    @StateObject private var viewRouter = ViewRouter()
    
    @State private var showIntroLottie = true

    
    init() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.setBackIndicatorImage(UIImage(named: "back"), transitionMaskImage: UIImage(named: "back"))
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .none
        UINavigationBar.appearance().standardAppearance = newAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            
            if showIntroLottie {
                LottieView(name: "lottie-intro", loopMode: .playOnce) {
                    showIntroLottie = false
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background(Color(.darkBlue))
            } else if showIntroLottie == false {
                ContentView()
                    .environmentObject(viewRouter)
                    .onAppear(perform: {
                        delegate.app = self
                    })
            }
        }
    }
}

extension BankingApp {
    func handleDeeplink(from url: URL) {
        viewRouter.handleDeeplink(from: url)
    }
}
