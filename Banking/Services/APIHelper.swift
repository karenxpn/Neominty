//
//  APIHelper.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import FirebaseFirestore
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
    
    func get_deleteRequest<T, P>(params: P?,
                              url: URL,
                              method: HTTPMethod = .get,
                              responseType: T.Type)
    -> AnyPublisher<T, Error> where T : Decodable, P : Encodable {
        
        let data = try! JSONEncoder.init().encode(params)
        let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]

        
        return AF.request(url,
                          method: method,
                          parameters: dictionary,
                          encoding: URLEncoding.default)
            .validate()
            .publishDecodable(type: T.self)
            .value()
            .mapError({ $0 as Error })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
        
//    func post_patchRequest<T, P>( params: P,
//                                  url: URL,
//                                  method: HTTPMethod = .post,
//                                  responseType: T.Type)
//    -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Decodable, P : Encodable {
//
//        var headers: HTTPHeaders?
//        if !token.isEmpty || !initialToken.isEmpty {
//            headers = ["Authorization": "Bearer \(token == "" ? initialToken : token)"]
//        }
//
//        return AF.request(url,
//                          method: method,
//                          parameters: params,
//                          encoder: JSONParameterEncoder.default,
//                          headers: headers)
//            .validate()
//            .publishDecodable(type: T.self)
//            .map { response in
//                response.mapError { error in
//                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
//                    return NetworkError(initialError: error, backendError: backendError)
//                }
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
}
