//
//  AccountViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import Foundation
class AccountViewModel: AlertViewModel, ObservableObject {
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var info: UserInfoViewModel?
    
    var manager: UserServiceProtocol
    init(manager: UserServiceProtocol = UserSerive.shared) {
        self.manager = manager
    }
    
    @MainActor func getAccountInfo() {
        loading = true
        Task {
            
            let result = await manager.fetchAccountInfo()
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let info):
                self.info = UserInfoViewModel(model: info)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func updateInfo(name: String, email: String?) {
        loading = true
        Task {
            
            let result = await manager.updateAccountInfo(name: name, email: email)
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name(NotificationName.infoUpdated.rawValue), object: nil)
            }
            if !Task.isCancelled {
                loading = true
            }
        }
    }
}
