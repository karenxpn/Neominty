//
//  PaymentDetails.swift
//  Banking
//
//  Created by Karen Mirakyan on 08.04.23.
//

import SwiftUI

struct PaymentDetails: View {
    @EnvironmentObject var payVM: PayViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var selectCard: Bool = false
    @State private var completed: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 42) {
                if payVM.loading {
                    ProgressView()
                } else if payVM.selectedCard != nil {
                    SelectCardButton(card: payVM.selectedCard!, buttonType: .popup) {
                        selectCard.toggle()
                    }
                }
                
                HStack(spacing: 10) {
                    
                    TextHelper(text: payVM.selectedCard?.currency.rawValue.currencySymbol ?? "USD", color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 40)
                    
                    TextField( NSLocalizedString("1000", comment: "") ,text: $payVM.amount)
                        .keyboardType(.decimalPad)
                        .foregroundColor(AppColors.darkBlue)
                        .font(.custom(Roboto.bold.rawValue, size: 40))
                        .frame(width: UIScreen.main.bounds.width * 0.3)
                }
                
                if let category = payVM.selectedPaymentCategory {
                    HStack {
                        VStack(alignment: .leading, spacing: 9) {
                            TextHelper(text: category.name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                            TextHelper(text: "Account Number: \(payVM.accountNumber)", color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 16)
                        }
                        Spacer()
                    }
                }
                
                ButtonHelper(disabled: payVM.amount.isEmpty
                             || payVM.selectedCard == nil
                             || payVM.loadingPayment,
                             label: payVM.loadingPayment
                             ? NSLocalizedString("pleaseWait", comment: "")
                             : NSLocalizedString("next", comment: "")) {
                    
                    payVM.performPayment()
                }.navigationDestination(isPresented: $completed) {
                    TransferSuccess(amount: payVM.amount, currency: payVM.selectedCard?.currency ?? CardCurrency.usd) {
                        viewRouter.popToHomeRoot()
                    }
                }
                
                
            }.padding(24)
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
        .task {
            payVM.getCards()
        }
        .sheet(isPresented: $selectCard) {
            if payVM.selectedCard != nil {
                
                if #available(iOS 16.4, *) {
                    SelectCardList(cards: payVM.cards,
                                   selectedCard: $payVM.selectedCard,
                                   show: $selectCard)
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(40)
                } else {
                    SelectCardList(cards: payVM.cards,
                                   selectedCard: $payVM.selectedCard,
                                   show: $selectCard)
                    .presentationDetents([.medium, .large])
                }

            }
        }.onReceive(NotificationCenter
            .default
            .publisher(for:Notification.Name(rawValue: NotificationName.paymentCompleted.rawValue))) { _ in
                completed.toggle()
        }.alert(NSLocalizedString("error", comment: ""), isPresented: $payVM.showAlert, actions: {
            Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
        }, message: {
            Text(payVM.alertMessage)
        }).navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaymentDetails_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetails()
            .environmentObject(PayViewModel())
    }
}
