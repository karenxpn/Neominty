//
//  FAQ.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import SwiftUI

struct FAQ: View {
    @EnvironmentObject var router: Router
    @StateObject private var faqVM = FAQViewModel()
    @State private var navigate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TextHelper(text: String(localized: .youHaveQuestion),
                       colorResource: .darkBlueText,
                       fontName: .bold,
                       fontSize: 24)
            
            // search bar
            HStack(spacing: 10) {
                Image("search")
                
                TextField(String(localized: .search), text: $faqVM.search)
                    .font(.custom(Roboto.regular.rawValue, size: 16))
                    .padding(.vertical, 16)
            }.padding(.horizontal, 18)
                .background(Color(.superLightGray))
                .cornerRadius(16)
            
            
            HStack {
                TextHelper(text: String(localized: .frequentlyAsked),
                           fontName: .bold,
                           fontSize: 20)
                Spacer()
                
                Button {
                    router.pushAccountPath(.allFaq)
                } label: {
                    TextHelper(text: String(localized: .viewAll),
                               fontName: .bold,
                               fontSize: 16)
                }
            }.padding(.top, 10)
            
            FAQList()
                .environmentObject(faqVM)
            
            
        }.padding(24)
            .alert(String(localized: .error), isPresented: $faqVM.showAlert, actions: {
                Button(String(localized: .gotIt), role: .cancel) { }
            }, message: {
                Text(faqVM.alertMessage)
            })
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: String(localized: .faq), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                }
            }.task {
                faqVM.getFAQs()
            }
    }
}

struct FAQ_Previews: PreviewProvider {
    static var previews: some View {
        FAQ()
    }
}
