//
//  TransactionPreview.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TransactionPreview: Identifiable, Codable {
    @DocumentID var id: String?
    var amount: Decimal
    var currency: String
    var name: String
    var recipientInfo: TransactionParticipantInfo
    var senderInfo: TransactionParticipantInfo
    var createdAt: Timestamp
    
}

struct TransactionParticipantInfo: Identifiable, Codable {
    var id: String?
    var name: String?
    var paymentType: TransactionType
}

struct TransactionPreviewViewModel: Identifiable {
    @AppStorage("userID") var userID: String = ""

    var model: TransactionPreview
    init(model: TransactionPreview) {
        self.model = model
    }
    
    var id: String              { self.model.id ?? UUID().uuidString }
    var name: String            { self.model.name }

    var icon: String {
        let info = self.model.recipientInfo.id == userID ? self.model.recipientInfo : self.model.senderInfo
        switch info.paymentType {
        case .phone:
            return "transaction-phone"
        case .gambling:
            return "transaction-gambling"
        case .received:
            return "notifications-request"
        case .sent:
            return "notifications-transfer"
        case .utility:
            return "utility-icon"
        case .unknown(_):
            return "notifications-default"
        }
    }
    
    var amount: String {
        let positive = self.model.recipientInfo.id == userID ? true : false
        return "\(positive ? "+" : "-") \(self.model.currency.currencySymbol)\(abs(self.model.amount))"
    }
}

enum TransactionType: RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case phone
    case gambling
    case utility
    case sent
    case received
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .phone,
        .gambling,
        .utility,
        .sent,
        .received
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .phone     : return "phone"
        case .gambling  : return "gambling"
        case .utility   : return "utility"
        case .sent      : return "sent"
        case .received  : return "received"
            
        case let .unknown(value)    : return value
        }
    }
}
