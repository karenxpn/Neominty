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
    @Published var categories = [PayCategoryViewModel]()
    
    var manager: PayServiceProtocol
    init(manager: PayServiceProtocol = PayService.shared) {
        self.manager = manager
    }
    
    @MainActor func getCategories() {
        loading = true
        Task {
            let result = await manager.fetchCategories()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let categories):
                self.categories = categories.map(PayCategoryViewModel.init)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
