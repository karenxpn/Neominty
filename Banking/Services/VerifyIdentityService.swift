//
//  VerifyIdentityService.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.10.23.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import FirebaseAuth

protocol VerifyIdentityProtocol {
    func getAccessToken(completion: @escaping(VerificationToken?) -> ())
}

class VerifyIdentityService {
    static let shared: VerifyIdentityProtocol = VerifyIdentityService()
}

extension VerifyIdentityService: VerifyIdentityProtocol {
    func getAccessToken(completion: @escaping (VerificationToken?) -> ()) {
        Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true, completion: { result, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            let url = URL(string: "\(Credentials.functions_base_url)getAccessToken")!
            let headers: HTTPHeaders? = ["Authorization": "Bearer \(result!.token )"]
            
            AF.request(url,
                       method: .get,
                       headers: headers).responseDecodable(of: VerificationToken.self) { (response) in
                        DispatchQueue.main.async {
                            completion( response.value)
                        }
            }
            
        })
    }
}
