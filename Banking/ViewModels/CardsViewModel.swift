//
//  CardsViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import Foundation
class CardsViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var cards = [CardModel]()
}
