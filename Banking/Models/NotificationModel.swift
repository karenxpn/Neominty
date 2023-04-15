//
//  NotificationModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 15.04.23.
//

import Foundation
struct NotificationModel: Codable, Identifiable {
    var id: String
    var title: String
    var body: String
    var read: Bool
    var createdAt: Date
    var type: NotificationType
}

struct NotificationModelViewModel: Identifiable {
    var model: NotificationModel
    
    init(model: NotificationModel) {
        self.model = model
    }
    
    var id: String          { self.model.id }
    var title: String       { self.model.title }
    var body: String        { self.model.body }
    var read: Bool          { self.model.read }
    var createdAt: String   { self.model.createdAt.countTimeBetweenDates()}
    
    var image: String {
        switch self.model.type {
        case .payment:
            return "notifications-payment"
        case .request:
            return "notifications-request"
        case .reward:
            return "notifications-reward"
        case .transfer:
            return "notifications-transfer"
        case .cashback:
            return "notifications-cashback"
        default:
            return "notifications-default"
        }
    }
}


