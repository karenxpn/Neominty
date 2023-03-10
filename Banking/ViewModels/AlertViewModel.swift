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
}
