//
//  FAQ.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import SwiftUI

struct FAQ: View {
    
    @StateObject private var faqVM = FAQViewModel()
    @State private var navigate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TextHelper(text: NSLocalizedString("youHaveQuestion", comment: ""),
                       colorResource: .darkBlue,
                       fontName: .bold,
                       fontSize: 24)
            
            // search bar
            HStack(spacing: 10) {
                Image("search")
                
                TextField(NSLocalizedString("search", comment: ""), text: $faqVM.search)
                    .font(.custom(Roboto.regular.rawValue, size: 16))
                    .padding(.vertical, 16)
            }.padding(.horizontal, 18)
                .background(Color(.superLightGray))
                .cornerRadius(16)
            
            
            HStack {
                TextHelper(text: NSLocalizedString("frequentlyAsked", comment: ""),
                           fontName: .bold,
                           fontSize: 20)
                Spacer()
                
                Button {
                    navigate.toggle()
                } label: {
                    TextHelper(text: NSLocalizedString("viewAll", comment: ""),
                               fontName: .bold,
                               fontSize: 16)
                }.navigationDestination(isPresented: $navigate) {
                    AllFAQs()
                }
            }.padding(.top, 10)
            
            FAQList()
                .environmentObject(faqVM)
            
            
        }.padding(24)
            .alert(NSLocalizedString("error", comment: ""), isPresented: $faqVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(faqVM.alertMessage)
            })
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("faq", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                }
            }
    }
}

struct FAQ_Previews: PreviewProvider {
    static var previews: some View {
        FAQ()
    }
}
