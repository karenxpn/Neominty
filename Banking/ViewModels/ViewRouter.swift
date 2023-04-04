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
    
    init() {
        if self.firstInstall {
            tab = 1
            self.firstInstall = false
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
}
