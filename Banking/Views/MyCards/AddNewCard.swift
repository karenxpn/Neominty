//
//  AddNewCard.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct AddNewCard: View {
    
    @StateObject private var cardsVM = CardsViewModel()
    
    @State private var navigate: Bool = false
    
    let designs: [CardDesign] = [.blue, .blueGreen, .green, .greenBlue]
    @State private var showAlert: Bool = false
    
    
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
                        ForEach(designs, id: \.id) { design in
                            CardStylingSelector(selectedItem: $cardsVM.design, cardDesign: design)
                        }
                    }.padding(.vertical, 15)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                }.padding(.top, 34)

                
                VStack( alignment: .leading, spacing: 16) {
                    
                    Spacer()
                    
                    ButtonHelper(disabled: cardsVM.loading, label: NSLocalizedString("continue", comment: "")) {
                        cardsVM.getOrderNumberAndRegister()
                    }.sheet(isPresented: $navigate, content: {
                        VPOS(active: $navigate)
                            .environmentObject(cardsVM)
                    }).fullScreenCover(isPresented: $showAlert) {
                        CongratulationAlert {
                            VStack(spacing: 12) {
                                TextHelper(text: NSLocalizedString("cardIsReady", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)

                                TextHelper(text: NSLocalizedString("cardIsReadyMessage", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)

                            }
                        }
                    }
                    
                }.padding(24)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            }
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
        .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("newCard", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $cardsVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(cardsVM.alertMessage)
            })
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: NotificationName.orderRegistered.rawValue))) { _ in
                navigate.toggle()
            }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: NotificationName.cardAttached.rawValue))) { _ in
                showAlert.toggle()
            }
    }
}

struct AddNewCard_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCard()
    }
}
