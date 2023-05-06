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

protocol CardServiceProtocol {
    func fetchCards() async -> Result<[CardModel], Error>
    func attachCards(cardNumber: String, cardHolder: String, expireDate: String, cvv: String) async -> Result<Void, Error>
    func removeCard(id: String) async -> Result<Void, Error>
    
    func registerOrder() async throws -> RegisterOrderResponse
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
    
    func registerOrder() async throws -> RegisterOrderResponse {
        let url = URL(string: "\(Credentials.functions_base_url)receiveGatewayForm")!
        do {
            let token = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true).token
            print(token)
            let headers: HTTPHeaders? = ["Authorization": "Bearer \(token ?? "")"]
            
            return try await withUnsafeThrowingContinuation({ continuation in
                AF.request(url,
                           method: .get,
                           headers: headers)
                .validate()
                .responseDecodable(of: RegisterOrderResponse.self) { response in
                    if let error = response.error {
                        continuation.resume(throwing: error)
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
    
    
    func removeCard(id: String) async -> Result<Void, Error> {
        return await APIHelper.shared.voidRequest {
            let token = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true)
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
