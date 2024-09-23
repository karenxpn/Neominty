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
    @Environment(\.scenePhase) private var phase


    var body: some View {
        
        Group {
            
            if authVM.authState == .authenticated {
                MainView()
            } else {
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
                }
            }
            
        }.task {
            authVM.checkPinExistence()
        }.onChange(of: phase) { newScene in
            switch newScene {
            case .background:
                if authVM.authState == .authenticated {
                    UserDefaults.standard.set(Date.now, forKey: "lastOnline")
                }
//            case .active:
//                if authVM.authState == .authenticated {
//                    print("determined authenticated state of the user")
//                    authVM.checkPinExistence()
//                }
            default:
                break
            }
        }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
