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
    @State private var countryPicker: Bool = false
    @State private var requestSuccess: Bool = false
    
    
    var body: some View {
        
        ZStack {
            if requestVM.loading {
                ProgressView()
            } else if !requestVM.loading && requestVM.cards.isEmpty {
                TextHelper(text: NSLocalizedString("attachCardToRequestTransfer", comment: ""),
                           fontName: Roboto.medium.rawValue)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 42) {
                        if requestVM.selectedCard != nil {
                            SelectCardButton(card: requestVM.selectedCard!, buttonType: .popup) {
                                selectCard.toggle()
                            }
                        }
                        
                        HStack(spacing: 10) {
                            
                            TextHelper(text: requestVM.selectedCard?.currency.rawValue.currencySymbol ?? "USD", color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 40)
                            
                            AmountTextField(text: $requestVM.amount, fontSize: 40)
                                .frame(width: UIScreen.main.bounds.width * 0.4)
                        }

                        
                        VStack(spacing: 9) {
                            RequestTypeList(selected: $requestVM.requestType)
                            
                            if requestVM.requestType == .email {
                                
                                CardDetailTextFieldDecorator(content: {
                                    TextField(NSLocalizedString("enterSenderEmail", comment: ""), text: $requestVM.email)
                                        .keyboardType(.emailAddress)
                                        .font(.custom(Roboto.regular.rawValue, size: 16))
                                        .onChange(of: requestVM.email) { newValue in
                                            requestVM.isEmailValid = newValue.isEmail
                                        }
                                }, isValid: $requestVM.isEmailValid)
                                // email field
                            } else if requestVM.requestType == .phone {
                                // phone field

                                HStack(spacing: 0) {
                                    
                                    Button {
                                        countryPicker.toggle()
                                    } label: {
                                        HStack {
                                            TextHelper(text: "\(requestVM.flag)",
                                                       fontName: Roboto.bold.rawValue, fontSize: 18)
                                            
                                            Image("drop_arrow")
                                            
                                        }.frame(height: 56)
                                            .padding(.horizontal, 10)
                                            .background(AppColors.superLightGray)
                                            .cornerRadius(16, corners: [.topLeft, .bottomLeft])
                                    }
                                    
                                    TextField(NSLocalizedString("enterSenderPhone", comment: ""), text: $requestVM.phoneNumber)
                                        .keyboardType(.phonePad)
                                        .font(.custom(Roboto.regular.rawValue, size: 16))
                                        .padding(.leading, 5)
                                        .frame(height: 56)
                                        .background(AppColors.superLightGray)
                                        .cornerRadius(16, corners: [.topRight, .bottomRight])
                                }
                            }
                        }
                        
                        ButtonHelper(disabled:
                                        (requestVM.requestType == .email && !requestVM.isEmailValid)
                                     || (requestVM.requestType == .phone && requestVM.phoneNumber.isEmpty)
                                     || (requestVM.amount.isEmpty)
                                     || (requestVM.selectedCard == nil)
                                     || (requestVM.loadingRequest), label: requestVM.loadingRequest ? NSLocalizedString("pleaseWait", comment: "") : NSLocalizedString("next", comment: "")) {
                            requestVM.requestPayment()
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
            }.sheet(isPresented: $countryPicker) {
                CountryCodeSelection(isPresented: $countryPicker, country: $requestVM.country, code: $requestVM.code, flag: $requestVM.flag)
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
            .onReceive(NotificationCenter.default.publisher(for:
                                                                Notification.Name(rawValue: NotificationName.requestPaymentSent.rawValue))) { _ in
                requestSuccess.toggle()
            }
    }
}

struct RequestTransfer_Previews: PreviewProvider {
    static var previews: some View {
        RequestTransfer()
    }
}
