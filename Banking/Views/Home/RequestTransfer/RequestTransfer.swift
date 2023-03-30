//
//  RequestTransfer.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import SwiftUI

struct RequestTransfer: View {
    
    @StateObject private var requestVM = RequestTransferViewModel()
    @State private var selectCard: Bool = false
    
    var body: some View {
        
        ZStack {
            if requestVM.loading {
                ProgressView()
            } else if !requestVM.loading && requestVM.cards.isEmpty {
                TextHelper(text: NSLocalizedString("attachCardToRequestTransfer", comment: ""),
                           fontName: Roboto.medium.rawValue)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        if requestVM.selectedCard != nil {
                            SelectCardButton(card: requestVM.selectedCard!, buttonType: .popup) {
                                selectCard.toggle()
                            }
                        }
                        
                    }.padding(24)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.15)
                }.padding(.top, 1)
            }
        }.navigationBarTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("request", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }.task {
                requestVM.getCards()
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $requestVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(requestVM.alertMessage)
            }).sheet(isPresented: $selectCard) {
                if requestVM.selectedCard != nil {
                    SelectCardList(cards: requestVM.cards,
                                   selectedCard: $requestVM.selectedCard,
                                   show: $selectCard)
                    .presentationDetents([.medium, .large])
                }
            }
    }
}

struct RequestTransfer_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransfer()
    }
}
