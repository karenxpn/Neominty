//
//  MockCardsService.swift
//  BankingTests
//
//  Created by Karen Mirakyan on 18.01.24.
//

import Foundation
@testable import Banking

class MockCardsService: CardServiceProtocol {
    
    var fetchCardsError: Bool = false
    var removeCardError: Bool = false
    var reorderCardsError: Bool = false
    var registerOrderError: Bool = false
    var attachCardError: Bool = false
    
    let globalResponse = GlobalResponse(status: "success", message: "Your card is attached")
    let registerOrderResponse = RegisterOrderResponse(orderNumber: "orderNumber")
    
    func fetchCards(userID: String) async -> Result<[CardModel], Error> {
        if fetchCardsError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error fetching cards"]))
            
        } else {
            return .success([PreviewModels.masterCard])
        }
    }
    
    func removeCard(userID: String, cardID: String) async -> Result<Void, Error> {
        if removeCardError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error removing your card"]))
            
        } else {
            return .success(())
        }
    }
    
    func reorderCards(userID: String, cards: [CardModel]) async -> Result<Void, Error> {
        if reorderCardsError {
            return .failure(NSError(domain: "Error",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Error reorderiing cards"]))
            
        } else {
            return .success(())
        }
    }
    
    func registerOrder() async throws -> RegisterOrderResponse {
        if registerOrderError {
            throw NSError(domain: "Error",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Error fetching user preferences"])
            
        } else {
            return registerOrderResponse
        }
    }
    
    func attachCard(orderNumber: String, orderId: String, cardStyle: CardDesign) async throws -> GlobalResponse {
        if attachCardError {
            throw             NSError(domain: "Error",
                                      code: 0,
                                      userInfo: [NSLocalizedDescriptionKey: "Error fetching user preferences"])
            
        } else {
            return globalResponse
        }
    }
}
