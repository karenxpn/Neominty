//
//  PayViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 07.04.23.
//

import Foundation
class PayViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    @Published var search: String = ""
}
