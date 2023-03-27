//
//  CardService.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import Foundation
protocol CardServiceProtocol {
    func fetchCards() async -> Result<[CardModel], Error>
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
            return .success([])
        } catch {
            return .failure(error)
        }
    }
}
