//
//  APIHelper.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine
import SwiftUI
import Alamofire


class APIHelper {
    static let shared = APIHelper()
    
    func voidRequest(action: () async throws -> Void) async -> Result<Void, Error> {
        do {
            try await action()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func httpRequest<T, P>(params: P?,
                           url: URL,
                           method: HTTPMethod = .get,
                           responseType: T.Type) async throws -> T where T : Decodable, P : Encodable {
        
        
        
        do {
            let data = try JSONEncoder.init().encode(params)
            let parameters = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            
            
            let token = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true).token
            let headers: HTTPHeaders? = ["Authorization": "Bearer \(token ?? "")"]
            
            return try await withUnsafeThrowingContinuation({ continuation in
                AF.request(url,
                           method: method,
                           parameters: parameters,
                           encoding: URLEncoding.queryString,
                           headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    
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
}
