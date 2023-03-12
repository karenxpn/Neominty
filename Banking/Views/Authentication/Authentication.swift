//
//  Authentication.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.03.23.
//

import SwiftUI

struct Authentication: View {
    @AppStorage("phoneNumber") var localPhone: String = ""
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
                
            }.navigationDestination(for: ViewPaths.self) { value in
                switch value {
                case .confirmPasscode:
                    ConfirmPin()
                        .environmentObject(authVM)
                case .enableBiometric:
                    EnableBiometricAuthentication()
                        .environmentObject(authVM)
                case .verifyPhoneNumber:
                    VerifyPhoneNumber(phone: localPhone, auth: false)
                        .environmentObject(authVM)
                case .setPasscode:
                    CreatePin()
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
