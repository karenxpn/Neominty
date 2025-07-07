//
//  Tabs.swift
//  Banking
//
//  Created by Karen Mirakyan on 21.06.25.
//
import Foundation

enum Tabs: Hashable, Equatable, CaseIterable {
    case home, cards, scan, activity, profile
    
    var icon: String {
        switch self {
        case .home:     "home_icon"
        case .cards:    "card_icon"
        case .activity: "activity_icon"
        case .profile:  "profile_icon"
        case .scan:     "scan_icon"
        }
    }
    
    var label: String {
        switch self {
        case .home:     String(localized: .home)
        case .cards:    String(localized: .myCards)
        case .activity: String(localized: .activity)
        case .profile:  String(localized: .profile)
        case .scan:     ""
        }
    }
}
