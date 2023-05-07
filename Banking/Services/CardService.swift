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
    func removeCard(id: String) async -> Result<Void, Error>
    
    func registerOrder() async throws -> RegisterOrderResponse
    func attachCard(orderNumber: String, orderId: String, cardStyle: CardDesign) async throws -> GlobalResponse
}

class CardService {
    static let shared: CardServiceProtocol = CardService()
    @AppStorage("userID") var userID: String = ""
    
    private init() { }
}

extension CardService: CardServiceProtocol {
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
            print(token)
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
}
