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
                    // make this card not default
                    try await db.collection(Paths.users.rawValue)
                        .document(userID)
                        .collection(Paths.cards.rawValue)
                        .document(cards[ind].id ?? "undefined")
                        .updateData([Paths.defaultCard.rawValue : false])
                }
                
                
                try await db.collection(Paths.users.rawValue)
                    .document(userID)
                    .collection(Paths.cards.rawValue)
                    .document(cards[0].id ?? "undefined")
                    .updateData([Paths.defaultCard.rawValue : true])
            }
            
            try await db.collection(Paths.users.rawValue)
                .document(userID)
                .updateData([Paths.orderRules.rawValue : cards.map{ $0.id }])
        }
    }
    
    func attachCard(orderNumber: String, orderId: String, cardStyle: CardDesign) async throws -> GlobalResponse {
        let url = URL(string: "\(Credentials.functions_base_url)attachCard")!
        let params: Parameters = [
            "orderId": orderId,
            "orderNumber": orderNumber,
            "cardStyle": cardStyle.rawValue
        ]
        
        do {
            let token = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true).token
            let headers: HTTPHeaders? = ["Authorization": "Bearer \(token ?? "")"]
            
            return try await withUnsafeThrowingContinuation({ continuation in
                AF.request(url,
                           method: .get,
                           parameters: params,
                           encoding: URLEncoding.queryString,
                           headers: headers)
                .validate()
                .responseDecodable(of: GlobalResponse.self) { response in

                    if response.error != nil {
                        response.error.map { err in
                            let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                            continuation.resume(throwing: NetworkError(initialError: err, backendError: backendError))
                        }
                    }
                    
                    if let registered = response.value {
                        continuation.resume(returning: registered)
                    }
                }
            })
        } catch {
            throw error
        }
        
    }
    
    func registerOrder() async throws -> RegisterOrderResponse {
        let url = URL(string: "\(Credentials.functions_base_url)receiveGatewayForm")!
        do {
            let token = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true).token
            let headers: HTTPHeaders? = ["Authorization": "Bearer \(token ?? "")"]
            
            return try await withUnsafeThrowingContinuation({ continuation in
                AF.request(url,
                           method: .get,
                           headers: headers)
                .validate()
                .responseDecodable(of: RegisterOrderResponse.self) { response in

                    if response.error != nil {
                        response.error.map { err in
                            let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                            continuation.resume(throwing: NetworkError(initialError: err, backendError: backendError))
                        }
                    }
                    
                    if let registered = response.value {
                        continuation.resume(returning: registered)
                    }
                }
            })
        } catch {
            throw error
        }
    }
    
    func removeCard(userID: String, cardID: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await db.collection(Paths.users.rawValue)
                .document(userID)
                .collection(Paths.cards.rawValue)
                .document(cardID)
                .delete()
        }
    }
    
    func fetchCards(userID: String) async -> Result<[CardModel], Error> {
        do {
            
            // get order rules
            
            let docs = try await db.collection(Paths.users.rawValue)
                .document(userID)
                .collection(Paths.cards.rawValue)
                .order(by: "createdAt", descending: true)
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
