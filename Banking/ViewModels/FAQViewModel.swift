//
//  FAQViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 18.06.23.
//

import Foundation
import Combine

class FAQViewModel: AlertViewModel, ObservableObject {
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var search: String = ""
    @Published var faqs = [FAQModel]()
    @Published var page = 0
    
    private var cancellableSet: Set<AnyCancellable> = []
    var manager: UserServiceProtocol
    init(manager: UserServiceProtocol = UserSerive.shared) {
        self.manager = manager
        super.init()
        
        $search
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { (text) in
                self.page = 0
                self.faqs.removeAll(keepingCapacity: false)
                Task { @MainActor [weak self] in
                    self?.getFAQs(searchText: text)
                }
            }.store(in: &cancellableSet)
    }
    
    
    @MainActor func getFAQs(searchText: String = "") {
        loading = true

        Task {
            do {
                let result = try await manager.fetchFaqs(query: searchText, page: page)
                self.faqs.append(contentsOf: result.hits)
                self.page += 1
            } catch let error as NetworkError {
                self.makeNetworkAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
