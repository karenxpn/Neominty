//
//  CardService.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import Foundation
protocol CardServiceProtocol {
    func fetchCards() async -> Result<[CardModel], Error>
    func attachCards(cardNumber: String, cardHolder: String, expireDate: String, cvv: String) async -> Result<Void, Error>
}

class CardService {
    static let shared: CardServiceProtocol = CardService()
    private init() { }
}

extension CardService: CardServiceProtocol {
    func fetchCards() async -> Result<[CardModel], Error> {
        do {
            let cards = [PreviewModels.masterCard, PreviewModels.visaCard, PreviewModels.mirCard, PreviewModels.arcaCard]
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
            return .success(cards)
        } catch {
            return .failure(error)
        }
    }
    
    func attachCards(cardNumber: String, cardHolder: String, expireDate: String, cvv: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
        }
    }
}
