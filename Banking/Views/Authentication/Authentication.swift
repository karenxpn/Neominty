//
//  Authentication.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import SwiftUI

struct Authentication: View {
    
    @StateObject private var authVM = AuthViewModel()
    @State private var paths = ["confirm", "biometric"]

    var body: some View {
        
        NavigationStack(path: $authVM.path) {
            ZStack {
                
                if authVM.loading {
                    ProgressView()
                } else if authVM.needNewPasscode {
                    CreatePin()
                        .environmentObject(authVM)
                } else {
                    AuthenticateWithPin()
    //                    .environmentObject(authVM)
                }
                
            }.task {
                authVM.checkPinExistence()
            }.navigationDestination(for: String.self) { value in
                if value == "confirm" {
                    ConfirmPin()
                        .environmentObject(authVM)
                } else if value == "biometric" {
                    EnableBiometricAuthentication()
                        .environmentObject(authVM)
                }
            }
        }        
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
