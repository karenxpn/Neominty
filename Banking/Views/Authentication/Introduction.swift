//
//  Introduction.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

struct Introduction: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var currentPage: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                if authVM.loading {
                    ProgressView()
                } else if !authVM.introductionPages.isEmpty {
                    IntroductionPage(introduction: authVM.introductionPages[currentPage],
                                     count: authVM.introductionPages.count,
                                     index: $currentPage)
                    .transition(.slide)

                }
                
            }.onAppear {
                authVM.getIntroductionPages()
            }
        }
    }
}

struct Introduction_Previews: PreviewProvider {
    static var previews: some View {
        Introduction()
    }
}
