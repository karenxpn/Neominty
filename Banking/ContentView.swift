//
//  ContentView.swift
//  Banking
//
//  Created by Karen Mirakyan on 09.03.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authVM = AuthViewModel()

    var body: some View {
        Group {
            
            if authVM.user != nil {
                Text("User here")
            } else {
                Introduction()
                    .environmentObject(authVM)
            }
            
        }.onAppear {
            authVM.listenToAuthState()
            authVM.signOut()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
