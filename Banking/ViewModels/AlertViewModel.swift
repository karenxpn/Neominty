//
//  AlertViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI

class AlertViewModel {
    
    func makeAlert(with error: Error, message: inout String, alert: inout Bool ) {
        message = error.localizedDescription
        alert.toggle()
    }
    
    func makeNetworkAlert(with error: NetworkError, message: inout String, alert: inout Bool ) {
        if let backendError = error.backendError {
            message = backendError.message
            alert.toggle()
        } else {
            self.makeAlert(with: error.initialError, message: &message, alert: &alert)
        }
    }
}
