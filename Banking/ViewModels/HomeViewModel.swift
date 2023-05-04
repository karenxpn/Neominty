//
//  HomeViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation
import SwiftUI


class HomeViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var cards: [CardModel] = [PreviewModels.masterCard, PreviewModels.visaCard,
                                         PreviewModels.mirCard, PreviewModels.amexCard]
    @Published var transactions = PreviewModels.transactionList
    @Published var hasUnreadNotification: Bool = false
    
    var notificationManager: NotificationsServiceProtocol
    init(notificationManager: NotificationsServiceProtocol = NotificationsService.shared) {
        self.notificationManager = notificationManager
        
        super.init()
        
        checkUnreadNotificationExistense()
    }
    
    func checkUnreadNotificationExistense() {
        notificationManager.checkForUnreadNotifications(userID: userID, completion: { response in
            self.hasUnreadNotification = response
        })
    }
}
