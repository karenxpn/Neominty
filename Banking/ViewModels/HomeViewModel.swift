//
//  HomeViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import Foundation

class HomeViewModel: AlertViewModel, ObservableObject {
    @Published var cards: [CardModel] = [PreviewModels.masterCard, PreviewModels.visaCard]
}
