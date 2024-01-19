//
//  NetworkError.swift
//  Banking
//
//  Created by Karen Mirakyan on 06.05.23.
//

import Foundation
import Foundation
import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var message: String
}
