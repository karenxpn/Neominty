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
    func requestOrderStatus(orderNumber: Int, orderId: String) -> AnyPublisher<OrderStatusResponse, Error>
}

class CardService {
    static let shared: CardServiceProtocol = CardService()
    @AppStorage("userID") var userID: String = ""
    
    private init() { }
}

extension CardService: CardServiceProtocol {
    func requestOrderStatus(orderNumber: Int, orderId: String) -> AnyPublisher<OrderStatusResponse, Error> {
        let url = URL(string: Credentials.base_url + "getOrderStatusExtended.do")!
        let params = OrderStatusRequest(userName: Credentials.username,
                                        password: Credentials.password,
                                        orderId: orderId,
                                        orderNumber: "G\(orderNumber)")
        
        return APIHelper.shared.get_deleteRequest(params: params, url: url, responseType: OrderStatusResponse.self)

    }
    
    func registerOrder() -> AnyPublisher<RegisterOrderResponse, Error> {
        let url = URL(string: "https://us-central1-banking-6e423.cloudfunctions.net/receiveGatewayForm")!
        return AF.request(url,
                          method: .get)
            .validate()
            .publishDecodable(type: RegisterOrderResponse.self)
            .value()
            .mapError({ $0 as Error })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
