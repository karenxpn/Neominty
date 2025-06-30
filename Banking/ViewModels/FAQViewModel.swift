//
//  FAQViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 18.06.23.
//

import Foundation
import Combine
import FirebaseFirestore

class FAQViewModel: AlertViewModel, ObservableObject {
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var search: String = ""
    @Published var faqs = [FAQModel]()
    @Published var lastDoc: QueryDocumentSnapshot?
    
    private var cancellableSet: Set<AnyCancellable> = []
    var manager: UserServiceProtocol
    init(manager: UserServiceProtocol = UserSerive.shared) {
        self.manager = manager
    }
    
    @MainActor func getFAQs() {
        loading = true
        
        Task {
            defer { loading = false }
            let result = await manager.fetchFaqs(lastDoc: lastDoc)
            print(result)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let res):
                print(res)
                self.faqs.append(contentsOf: res.0)
                print(self.faqs)
                self.lastDoc = res.1
            }
        }
    }
}
