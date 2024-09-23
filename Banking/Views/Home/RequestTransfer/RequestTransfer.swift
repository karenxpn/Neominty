//
//  RequestTransfer.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import SwiftUI

struct RequestTransfer: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var requestVM = RequestTransferViewModel()
    @State private var selectCard: Bool = false
    @State private var requestSuccess: Bool = false
    
    var body: some View {
        
        ZStack {
            if requestVM.loading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 75) {
                        
                        if !requestVM.loading && !requestVM.alertMessage.isEmpty && requestVM.cards.isEmpty {
                            ViewFailedToLoad {
                                requestVM.getCards()
                            }
                        } else {
                            if !requestVM.loading && requestVM.cards.isEmpty && requestVM.alertMessage.isEmpty {
                                AttachCardButtonLikeSelect {
                                    viewRouter.pushHomePath(.attachCard)
                                }
                            } else if requestVM.selectedCard != nil {
                                SelectCardButton(card: requestVM.selectedCard!, buttonType: .popup) {
                                    selectCard.toggle()
                                }
                            }
                            
                            HStack(spacing: 10) {
                                
                                TextHelper(text: requestVM.selectedCard?.currency.rawValue.currencySymbol ?? "USD".currencySymbol, colorResource: .appGray, fontName: .bold, fontSize: 40)
                                
                                AmountTextField(text: $requestVM.amount, fontSize: 40)
                                    .frame(width: UIScreen.main.bounds.width * 0.4)
                            }
                            
                            ButtonHelper(disabled: (requestVM.loadingRequest) || (requestVM.selectedCard == nil), label: requestVM.loadingRequest ? NSLocalizedString("pleaseWait", comment: "") : NSLocalizedString("next", comment: "")) {
                                requestVM.requestPayment()
                            }
                        }
                        
                        
                    }.padding(24)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.15)
                }.padding(.top, 1)
                    .scrollDismissesKeyboard(.immediately)
            }
        }.navigationBarTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("request", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                }
            }.task {
                requestVM.getCards()
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $requestVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(requestVM.alertMessage)
            }).sheet(isPresented: $selectCard) {
                if requestVM.selectedCard != nil {
                    
                    if #available(iOS 16.4, *) {
                        SelectCardList(cards: requestVM.cards,
                                       selectedCard: $requestVM.selectedCard,
                                       show: $selectCard)
                        .presentationDetents([.medium, .large])
                        .presentationCornerRadius(40)
                    } else {
                        SelectCardList(cards: requestVM.cards,
                                       selectedCard: $requestVM.selectedCard,
                                       show: $selectCard)
                        .presentationDetents([.medium, .large])
                    }
                    
                }
            }.sheet(isPresented: $requestSuccess, content: {
                
                if #available(iOS 16.4, *) {
                    RequestTransferSuccess()
                        .environmentObject(requestVM)
                        .presentationDetents([.fraction(0.7)])
                        .presentationCornerRadius(40)
                } else {
                    RequestTransferSuccess()
                        .environmentObject(requestVM)
                        .presentationDetents([.fraction(0.7)])
                }
            })
            .onReceive(NotificationCenter.default.publisher(for:Notification.Name(rawValue: NotificationName.requestPaymentSent.rawValue))) { _ in
                requestSuccess.toggle()
            }
    }
}

struct RequestTransfer_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransfer()
    }
}
