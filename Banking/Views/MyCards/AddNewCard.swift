//
//  AddNewCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct AddNewCard: View {
    
    @EnvironmentObject var router: Router
    @StateObject private var cardsVM = CardsViewModel()
    
    @State private var navigate: Bool = false
    
    let designs: [CardDesign : [CardDesign]] = [.hex : [.hexBlue, .hexGreen, .hexGreenBlue, .hexBlueGreen],
                                                .standard: [.standardBlue, .standardGreen, .standardBlueGreen, .standardGreenBlue],
                                                .signed: [.signedBlueGreen, .signedGreenBlue]]
    let style: CardDesign
        
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 16)  {
                ZStack( alignment: .trailing) {
                    CardStyling(cardNumber: $cardsVM.cardNumber,
                                cardType: $cardsVM.cardType,
                                cardHolder: $cardsVM.cardHolder,
                                expireDate: $cardsVM.expirationDate,
                                cardDesign: $cardsVM.design)
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 16) {
                        if let subDesignes = designs[style] {
                            ForEach(subDesignes, id: \.id) { design in
                                CardStylingSelector(selectedItem: $cardsVM.design, cardDesign: design)
                            }
                        }

                    }.padding(.vertical, 15)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                }.padding(.top, 34)

                
                VStack( alignment: .leading, spacing: 16) {
                    
                    Spacer()
                    
                    ButtonHelper(disabled: cardsVM.loading, label: cardsVM.loading ? String(localized: .pleaseWait) : String(localized: .`continue`)) {
                        cardsVM.registerOrder()
                    }.sheet(isPresented: $navigate, content: {
                        VPOS(active: $navigate)
                            .environmentObject(cardsVM)
                    })
                    
                }.padding(24)
            }
            
        }.padding(.top, 1)
            .onAppear {
                cardsVM.design = designs[style]?.first ?? .standardBlue
            }
            .scrollDismissesKeyboard(.immediately)
        .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: String(localized: .newCard), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                }
            }.alert(String(localized: .error), isPresented: $cardsVM.showAlert, actions: {
                Button(String(localized: .gotIt), role: .cancel) { }
            }, message: {
                Text(cardsVM.alertMessage)
            })
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: NotificationName.orderRegistered.rawValue))) { _ in
                navigate.toggle()
            }
    }
}

struct AddNewCard_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCard(style: .standard)
    }
}
