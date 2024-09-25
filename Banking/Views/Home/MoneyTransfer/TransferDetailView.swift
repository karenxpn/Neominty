//
//  TransferDetailView.swift
//  Banking
//
//  Created by Karen Mirakyan on 21.03.23.
//

import SwiftUI

struct TransferDetailView: View {
    @EnvironmentObject var transferVM: TransferViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isNameValid: Bool = false
    @State private var cardHolder: String = ""
    @State private var cardType = CreditCardType.nonIdentified
    @State private var navigateToConfirmation: Bool = false
    @State private var showGallery: Bool = false

    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 24) {
                
                if let recentTransfer = transferVM.selectedTransfer {
                    
                    ZStack {
                        if let image = recentTransfer.image {
                            ImageHelper(image: image, contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                        } else {
                            Image("anonymous-mask")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                        }
                        
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 110, height: 110)
                    }
                    
                    TextHelper(text: "\(NSLocalizedString("to", comment: "")) \(recentTransfer.name)",
                               colorResource: .darkBlue,
                               fontName: .bold,
                               fontSize: 14)
                    
                } else {
                    
                    ZStack {
                        
                        Button {
                            showGallery.toggle()
                        } label: {
                            if transferVM.newTransferImage == nil {
                                Image("plus-sign")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                            } else {
                                Image(uiImage: UIImage(data: transferVM.newTransferImage!) ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                
                            }
                        }
                        
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 110, height: 110)
                    }
                    
                    CardValidationTF(text: $cardHolder,
                                     isValid: $isNameValid,
                                     bankCardType: $cardType,
                                     tfType: .cardHolder,
                                     tfFont: .custom(Roboto.bold.rawValue, size: 14),
                                     tfColor: Color(.darkBlue),
                                     subtitle: NSLocalizedString("enterFullName", comment: ""))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(!isNameValid && !cardHolder.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.superLightGray))
                            }
                        
                    }
                }
                
                VStack {
                    HStack {
                        TextHelper(text: NSLocalizedString("enterAmount", comment: ""), colorResource: .appGray,
                                   fontName: .medium, fontSize: 12)
                        
                        Spacer()
                        
                        TextHelper(text: NSLocalizedString("max $12,652", comment: ""), colorResource: .appGray,
                                   fontName: .medium, fontSize: 12)
                    }.padding(16)
                    
                    HStack {
                        TextHelper(text: "\(transferVM.selectedCard?.currency.rawValue ?? "USD")", colorResource: .appGray, fontName: .medium, fontSize: 16)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.lightGray))
                            }
                        
                        AmountTextField(text: $transferVM.transferAmount, fontSize: 24)
                        
                        
                    }.padding([.horizontal, .bottom], 16)
                }.background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(.lightGray), lineWidth: 1)
                }
                
                // add amount validation
                ButtonHelper(disabled: (!isNameValid && transferVM.selectedTransfer == nil), label: NSLocalizedString("sendMoney", comment: "")) {
                    navigateToConfirmation.toggle()
                    
                }.padding(.top, 12)
                    .fullScreenCover(isPresented: $navigateToConfirmation) {
                        CustomAlert {
                            
                            VStack(spacing: 31) {
                                TextHelper(text: "Transfer Confirmation", colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                                
                                
                                TransferConfirmationCell(direction: NSLocalizedString("from", comment: ""),
                                                         bank: "Bank name",
                                                         name: transferVM.selectedCard!.cardHolder,
                                                         card: transferVM.selectedCard!.cardPan)
                                
                                TransferConfirmationCell(direction: NSLocalizedString("to", comment: ""),
                                                         bank: "User's bank here",
                                                         name: transferVM.selectedTransfer == nil ? cardHolder : transferVM.selectedTransfer!.name,
                                                         card: transferVM.cardNumber)
                                
                                HStack {
                                    TextHelper(text: "Total", colorResource: .darkBlue, fontName: .bold, fontSize: 16)
                                    Spacer()
                                    TextHelper(text: "\(transferVM.selectedCard?.currency.rawValue.currencySymbol ?? CardCurrency.usd.rawValue.currencySymbol)\(transferVM.transferAmount)", colorResource: .darkBlue, fontName: .bold, fontSize: 16)
                                }
                                
                            }
                            
                        } action: {
                            // start transaction
                            transferVM.startTransaction()
                        }
                    }
                
            }.padding(.horizontal, 24)
                .padding(.top, 40)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextHelper(text: NSLocalizedString("sendMoney", comment: ""), color: .black, fontName: .bold, fontSize: 20)
                    }
                    
                }
            }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "transferSuccess"))) { _ in
                viewRouter.pushHomePath(.transferSuccess(amount: transferVM.transferAmount,
                                                         currency: transferVM.selectedCard?.currency ?? CardCurrency.usd,
                                                         action: CustomAction(action: {
                    viewRouter.popToHomeRoot()

                })))
            }.sheet(isPresented: $showGallery, content: {
                Gallery { image in
                    // store image
                }
            })
    }

}

struct TransferDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransferDetailView()
            .environmentObject(TransferViewModel())
            .environmentObject(ViewRouter())
    }
}
