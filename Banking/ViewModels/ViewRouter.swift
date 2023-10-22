//
//  ViewRouter.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    @AppStorage("firstInstall") var firstInstall: Bool = true
    
    @Published var tab: Int = 0
    @Published var homePath = NavigationPath()
    @Published var cardPath = NavigationPath()
    @Published var scanPath = NavigationPath()
    @Published var analyticsPath = NavigationPath()
    @Published var accountPath = NavigationPath()
    
    @AppStorage("userID") var userID: String = ""
    @AppStorage("fullName") var localName: String = ""


    var accountManager: UserServiceProtocol
    
    init(accountManager: UserServiceProtocol = UserSerive.shared) {
        self.accountManager = accountManager
        
        if self.firstInstall {
            tab = 1
            self.firstInstall = false
        }
    }
    
    @MainActor func getAccountInfo() {
        Task {
            
            let result = await accountManager.fetchAccountInfo(userID: userID)
            switch result {
            case .failure(_):
                break
            case .success(let info):
                self.localName = info.name ?? ""
            }
        }
    }
    
    @ViewBuilder
    func buildHomeView(page: HomeViewPaths) -> some View {
        switch page {
        case .allTransactions:
            AllTransactions()
        case .send(let cards):
            MoneyTransfer(cards: cards)
        case .pay:
            ViewInDevelopmentMode()
        case .receive:
            RequestTransfer()
        case .more:
            MoreTransfers()
        case .notifications:
            Notifications()
        case .attachCard:
            SelectCardStyle()
        case .transferSuccess(let amount, let currency, let action):
            TransferSuccess(amount: amount, currency: currency) {
                action.action()
            }
        }
    }
        
    @ViewBuilder
    func buildAccountView(page: AccountViewPaths) -> some View {
        switch page {
        case .settings:
            GeneralSettings()
        case .changePin:
            CheckPin()
        case .info(let name, let flag, let phone, let email):
            AccountInfo(name: name,
                        flag: flag,
                        phone: phone,
                        email: email)
        case .faq:
            FAQ()
        case .verifyAccount:
            IdentityVerification()
        case .accountVerified:
            AccountVerificationApproved()
        case .accountRejected:
            AccountVerificationRejected()
        }
    }
    
    // add new view
    func pushHomePath(_ page: HomeViewPaths) {
        homePath.append(page)
    }
    
    func pushCardPath(_ page: MyCardViewPaths) {
        cardPath.append(page)
    }
    
    func pushScanPath(_ page: ScanViewPaths) {
        scanPath.append(page)
    }
    
    func pushAnalyicsPath(_ page: AnalyticsViewPaths) {
        analyticsPath.append(page)
    }
    
    func pushAccountPath(_ page: AccountViewPaths) {
        accountPath.append(page)
    }
    
    // pop one view
    func popHomaPath() {
        homePath.removeLast()
    }
    
    func popCardPath() {
        cardPath.removeLast()
    }
    
    func popScanPath() {
        scanPath.removeLast()
    }
    
    func popAnalyticsPath() {
        analyticsPath.removeLast()
    }
    
    func popAccountPath() {
        accountPath.removeLast()
    }
    
    // pop root view
    
    func popToHomeRoot() {
        homePath.removeLast(homePath.count)
    }
    
    func popToCardRoot() {
        cardPath.removeLast(cardPath.count)
    }
    
    func popToScanRoot() {
        scanPath.removeLast(scanPath.count)
    }
    
    func popToAnalyticsRoot() {
        analyticsPath.removeLast(analyticsPath.count)
    }
    
    func popToAccountRoot() {
        accountPath.removeLast(accountPath.count)
    }
    
    func handleDeeplink(from url: URL) {
        guard let host = url.host() else { return }
        
        if host == "neominty.page.link" {
            
            print("Hello firebase")
            
        } else {
            
            if url.pathComponents.count >= 2 {
                
                let destination = url.pathComponents[1]
                switch DeeplinkURLs(rawValue: host) {
                case .home:
                    tab = 0
                    if DeeplinkURLs(rawValue: destination) == .transferSuccess {
                        let queryParams = url.queryParameters
                        guard let amount = queryParams?["amount"] as? String,
                              let currency = queryParams?["currency"] as? String else { return }
                        
                        self.pushHomePath(.transferSuccess(amount: amount, currency: CardCurrency(rawValue: currency), action: CustomAction(action: {
                            self.popToHomeRoot()
                        })))
                    } else if DeeplinkURLs(rawValue: destination) == .notifications {
                        self.pushHomePath(.notifications)
                    }
                case .cards:
                    tab = 1
                case .qr:
                    tab = 2
                case .account:
                    tab = 4
                    if DeeplinkURLs(rawValue: destination) == .accountVerified {
                        self.pushAccountPath(.accountVerified)
                    } else if DeeplinkURLs(rawValue: destination) == .accountRejected {
                        self.pushAccountPath(.accountRejected)
                    } else if DeeplinkURLs(rawValue: destination) == .verifyAccount {
                        self.pushAccountPath(.verifyAccount)
                    }
                default:
                    return
                }
                
            } else {
                
            }
        }
    }
}
