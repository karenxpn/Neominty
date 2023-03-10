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
}
