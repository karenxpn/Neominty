//
//  TransferDetailView.swift
//  Banking
//
//  Created by Karen Mirakyan on 21.03.23.
//

import SwiftUI

struct TransferDetailView: View {
    @EnvironmentObject var transferVM: TransferViewModel
    @State private var isNameValid: Bool = false
    @State private var cardHolder: String = ""
    @State private var cardType = CardBankType.nonIdentified

    
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
                               color: AppColors.darkBlue,
                               fontName: Roboto.bold.rawValue,
                               fontSize: 14)
                    
                } else {
                    
                    ZStack {
                        
                        Button {
                            
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
                                     tfColor: AppColors.darkBlue,
                                     subtitle: NSLocalizedString("enterFullName", comment: ""))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(!isNameValid ? Color.red : Color.clear, lineWidth: 1)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.superLightGray)
                            }
                        
                    }
                }
                
                VStack {
                    HStack {
                        TextHelper(text: NSLocalizedString("enterAmount", comment: ""), color: AppColors.gray,
                                   fontName: Roboto.medium.rawValue, fontSize: 12)
                        
                        Spacer()
                        
                        TextHelper(text: NSLocalizedString("max $12,652", comment: ""), color: AppColors.gray,
                                   fontName: Roboto.medium.rawValue, fontSize: 12)
                    }.padding(16)
                    
                    HStack {
                        TextHelper(text: "USD", color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 16)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.lightGray)
                            }
                        
                        TextField("10", text: $transferVM.transferAmount)
                            .keyboardType(.phonePad)
                            .font(.custom(Roboto.bold.rawValue, size: 24))
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.leading, 5)
                            .frame(height: 31)
                        
                    }.padding([.horizontal, .bottom], 16)
                }.background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppColors.lightGray, lineWidth: 1)
                }
                
                // add amount validation
                ButtonHelper(disabled: (!isNameValid && transferVM.selectedTransfer == nil), label: NSLocalizedString("sendMoney", comment: "")) {
                    
                }.padding(.top, 12)
                
            }.padding(.horizontal, 24)
                .padding(.top, 40)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
        }.padding(.top, 1)
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextHelper(text: NSLocalizedString("sendMoney", comment: ""), color: .black, fontName: Roboto.bold.rawValue, fontSize: 20)
                    }
                    
                }
            }
    }
}

struct TransferDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransferDetailView()
            .environmentObject(TransferViewModel())
    }
}
