//
//  TransferDetailView.swift
//  Banking
//
//  Created by Karen Mirakyan on 21.03.23.
//

import SwiftUI
import Introspect

struct TransferDetailView: View {
    @EnvironmentObject var transferVM: TransferViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isNameValid: Bool = false
    @State private var cardHolder: String = ""
    @State private var cardType = CreditCardType.nonIdentified
    @State private var navigateToConfirmation: Bool = false
    @State private var navigateToSuccess: Bool = false

    
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
                        TextHelper(text: "\(transferVM.selectedCard?.currency.rawValue ?? "USD")", color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 16)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.lightGray)
                            }
                        
                        AmountTextField(text: $transferVM.transferAmount, fontSize: 24)
                        
                        
                    }.padding([.horizontal, .bottom], 16)
                }.background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppColors.lightGray, lineWidth: 1)
                }
                
                // add amount validation
                ButtonHelper(disabled: (!isNameValid && transferVM.selectedTransfer == nil), label: NSLocalizedString("sendMoney", comment: "")) {
                    navigateToConfirmation.toggle()
                    
                }.padding(.top, 12)
                    .fullScreenCover(isPresented: $navigateToConfirmation) {
                        CustomAlert {
                            
                            VStack(spacing: 31) {
                                TextHelper(text: "Transfer Confirmation", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                                
                                
                                TransferConfirmationCell(direction: NSLocalizedString("from", comment: ""),
                                                         bank: "Bank name",
                                                         name: transferVM.selectedCard!.cardHolder,
                                                         card: transferVM.selectedCard!.number)
                                
                                TransferConfirmationCell(direction: NSLocalizedString("to", comment: ""),
                                                         bank: "User's bank here",
                                                         name: transferVM.selectedTransfer == nil ? cardHolder : transferVM.selectedTransfer!.name,
                                                         card: transferVM.cardNumber)
                                
                                HStack {
                                    TextHelper(text: "Total", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                                    Spacer()
                                    TextHelper(text: "\(transferVM.selectedCard?.currency.rawValue.currencySymbol ?? CardCurrency.usd.rawValue.currencySymbol)\(transferVM.transferAmount)", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                                }
                                
                            }
                            
                        } action: {
                            // start transaction
                            transferVM.startTransaction()
                        }
                    }.navigationDestination(isPresented: $navigateToSuccess) {
                        TransferSuccess(amount: transferVM.transferAmount,
                                        currency: transferVM.selectedCard?.currency ?? CardCurrency.usd) {
                            viewRouter.popToHomeRoot()
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
                        TextHelper(text: NSLocalizedString("sendMoney", comment: ""), color: .black, fontName: Roboto.bold.rawValue, fontSize: 20)
                    }
                    
                }
            }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "transferSuccess"))) { _ in
                navigateToSuccess.toggle()
            }
    }

}

struct TransferDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransferDetailView()
            .environmentObject(TransferViewModel())
    }
}



class TextFieldDelegate: NSObject, UITextFieldDelegate {
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.maximum = NSNumber(value: Double.greatestFiniteMagnitude)
        return formatter
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text and cursor position
        var text = textField.text ?? ""
        let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: textField.selectedTextRange?.start ?? textField.endOfDocument)
        
        // Insert the new string into the text
        text = text.replacingCharacters(in: Range(range, in: text)!, with: string)
        
        // Remove any commas or periods from the text
        let value = text.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
        
        // Convert the text to a Double value
        if let doubleValue = Double(value) {
            let number = NSNumber(value: doubleValue / 100.0)
            text = formatter.string(from: number) ?? ""
        } else {
            text = ""
        }
        
        // Set the text and cursor position
        textField.text = text
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition + string.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        // Return false to prevent the textfield from updating the text
        return false
    }

}
