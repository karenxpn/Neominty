//
//  CardService.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

protocol CardServiceProtocol {
    func fetchCards(userID: String) async -> Result<[CardModel], Error>
    func removeCard(userID: String, cardID: String) async -> Result<Void, Error>
    func reorderCards(userID: String, cards: [CardModel]) async -> Result<Void, Error>
    
    func registerOrder() async throws -> RegisterOrderResponse
    func attachCard(orderNumber: String, orderId: String, cardStyle: CardDesign) async throws -> GlobalResponse
}

class CardService {
    static let shared: CardServiceProtocol = CardService()
    @AppStorage("userID") var userID: String = ""
    let db = Firestore.firestore()
    var function = Functions.functions()
    
    private init() { }
}

extension CardService: CardServiceProtocol {
    func reorderCards(userID: String, cards: [CardModel]) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            if !cards[0].defaultCard {
                
                // if this is not the default card ->
                // make this card default
                
                // find the card that is default card and make it not default
                if let ind = cards.firstIndex(where: {$0.defaultCard}) {
                    print("ind = ", ind)
                    // make this card not default
                    try await db.collection(Paths.cards.rawValue)
                        .document(cards[ind].id ?? "undefined")
                        .updateData([Paths.defaultCard.rawValue : false])
                }
                
                
                try await db.collection(Paths.cards.rawValue)
                    .document(cards[0].id ?? "undefined")
                    .updateData([Paths.defaultCard.rawValue : true])
            }
            
            try await db.collection(Paths.users.rawValue)
                .document(userID)
                .updateData([Paths.orderRules.rawValue : cards.map{ $0.id }])
        }
    }
    
    func attachCard(orderNumber: String, orderId: String, cardStyle: CardDesign) async throws -> GlobalResponse {
        let params = [
            "orderId": orderId,
            "orderNumber": orderNumber,
            "cardStyle": cardStyle.rawValue
        ]
        
        do {
            return try await APIHelper.shared.onCallRequest(params: params, name: "attachCard", responseType: GlobalResponse.self)
        } catch {
            throw error
        }
    }
    
    func registerOrder() async throws -> RegisterOrderResponse {
        return try await APIHelper.shared.onCallRequest(name: "receiveGatewayForm",
                                                        responseType: RegisterOrderResponse.self)
    }
    
    func removeCard(userID: String, cardID: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(Paths.cards.rawValue)
                .document(cardID)
                .delete()
        }
    }
    
    func fetchCards(userID: String) async -> Result<[CardModel], Error> {
        do {
            
            // get order rules
            let docs = try await db.collection(Paths.cards.rawValue)
                .whereField("userId", isEqualTo: userID)
                .order(by: "createdAt", descending: false)
                .getDocuments().documents
            
            let cards = try docs.map { try $0.data(as: CardModel.self ) }
            
            let orderRules = try await db.collection(Paths.users.rawValue)
                .document(userID)
                .getDocument()
                .get(Paths.orderRules.rawValue) as? [String]
            
            var orderedCards = [CardModel]()
            if let orderRules {
                for rule in orderRules {
                    if let card = cards.first(where: {$0.id == rule }) {
                        orderedCards.append(card)
                    }
                }
                
                for card in cards {
                    if orderRules.contains(where: {$0 == card.id }) == false {
                        orderedCards.append(card)
                    }
                }
                
            } else {
                orderedCards = cards
            }
            
            
            return .success(orderedCards
            )
        } catch {
            return .failure(error)
        }
    }
}
