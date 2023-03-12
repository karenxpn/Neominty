//
//  Authentication.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import SwiftUI

struct Authentication: View {
    
    @StateObject private var authVM = AuthViewModel()

    var body: some View {
        
        NavigationStack(path: $authVM.path) {
            ZStack {
                
                if authVM.authState == .notDetermind {
                    ProgressView()
                } else if authVM.authState == .setPasscode {
                    CreatePin()
                        .environmentObject(authVM)
                } else if authVM.authState == .enterPasscode {
                    AuthenticateWithPin()
                        .environmentObject(authVM)
                } else if authVM.authState == .authenticated {
                    Text( "authenticated" )
                }
                
            }.navigationDestination(for: String.self) { value in
                if value == ViewPaths.confirmPasscode.rawValue {
                    ConfirmPin()
                        .environmentObject(authVM)
                } else if value == ViewPaths.enableBiometric.rawValue {
                    EnableBiometricAuthentication()
                        .environmentObject(authVM)
                }
            }
        }      .task {
            authVM.checkPinExistence()
        }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
