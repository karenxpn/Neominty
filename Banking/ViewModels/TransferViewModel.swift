//
//  TransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
class TransferViewModel: AlertViewModel, ObservableObject {
    @Published var selectedCard: CardModel?
    @Published var cardNumber: String = ""
    @Published var transactionUsers = []
}
