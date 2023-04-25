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

protocol CardServiceProtocol {
    func fetchCards() async -> Result<[CardModel], Error>
    func attachCards(cardNumber: String, cardHolder: String, expireDate: String, cvv: String) async -> Result<Void, Error>
    func removeCard(id: String) async -> Result<Void, Error>
    
    func registerOrder() -> AnyPublisher<RegisterOrderResponse, Error>
}

class CardService {
    static let shared: CardServiceProtocol = CardService()
    @AppStorage("userID") var userID: String = ""
    
    private init() { }
}

extension CardService: CardServiceProtocol {
    func registerOrder() -> AnyPublisher<RegisterOrderResponse, Error> {
        let url = URL(string: Credentials.base_url + "register.do" )!
        let params = RegisterOrderRequest(userName: Credentials.username,
                                          password: Credentials.password,
                                          orderNumber: "G226",
                                          amount: 100,
                                          returnUrl: "https://neominty.com/",
//                                          pageView: "MOBILE",
                                          clientId: userID)
        return APIHelper.shared.get_deleteRequest(params: params, url: url, responseType: RegisterOrderResponse.self)
    }
    
    
    func removeCard(id: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        }
    }
    
    func fetchCards() async -> Result<[CardModel], Error> {
        do {
            let cards = [PreviewModels.masterCard, PreviewModels.visaCard, PreviewModels.mirCard, PreviewModels.amexCard]
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            return .success(cards)
        } catch {
            return .failure(error)
        }
    }
    
    func attachCards(cardNumber: String, cardHolder: String, expireDate: String, cvv: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        }
    }
}
