//
//  ScannedQR.swift
//  Banking
//
//  Created by Karen Mirakyan on 21.05.23.
//

import SwiftUI
import CodeScanner

struct ScannedQR: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var qrVM: QrViewModel
    
    let result: String
    @Binding var amount: String
    @Binding var presented: Bool

    @State private var selectCard: Bool = false

    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        
        ZStack {
            Color(.darkGray)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false, content: {
                VStack(spacing: 20) {
                    
                    Spacer()
                    
                    ZStack {
                        Image(uiImage: generateQRCode(from: result))
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 157, height: 157)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color(.shadow), radius: 25, x: 2, y: 15)
                        
                        Image("scan-success")
                    }
                    
                    if qrVM.selectedCard != nil {
                        SelectCardButton(card: qrVM.selectedCard!, buttonType: .popup) {
                            selectCard.toggle()
                        }
                    }
                    
                    VStack {
                        HStack {
                            TextHelper(text: NSLocalizedString("enterAmount", comment: ""),
                                       colorResource: .appGray,
                                       fontName: .medium, fontSize: 12)
                            
                            Spacer()
                            
                            TextHelper(text: NSLocalizedString("max $12,652", comment: ""), colorResource: .appGray,
                                       fontName: .medium, fontSize: 12)
                        }.padding(16)
                        
                        HStack {
                            TextHelper(text: qrVM.selectedCard?.currency.rawValue ?? "USD", colorResource: .appGray, fontName: .medium, fontSize: 16)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.lightGray))
                                }
                            
                            AmountTextField(text: $amount, fontSize: 24)
                            
                        }.padding([.horizontal, .bottom], 16)
                    }.background {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color(.lightGray), lineWidth: 1)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                            }
                    }
                    
                    ButtonHelper(disabled: amount.isEmpty
                                 || qrVM.loadingPayment
                                 || qrVM.selectedCard == nil,
                                 label: qrVM.loadingPayment ? NSLocalizedString("pleaseWait", comment: "") : NSLocalizedString("sendMoney", comment: "")) {
                        qrVM.performPayment(receiver: result,
                                            amount: amount, action: {
                            print(viewRouter.scanPath.count)

                            presented.toggle()
                            viewRouter.pushScanPath(.transferSuccess(amount: amount,
                                                                     currency: qrVM.selectedCard!.currency,
                                                                     action: CustomAction(action: {
                                viewRouter.popToScanRoot()
                            })))
                            
                            print(viewRouter.scanPath.count)
                        })
                    }
                    
                }.padding(24)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    .padding(.top, 50)
            })
        }.sheet(isPresented: $selectCard) {
            if qrVM.selectedCard != nil {
                
                if #available(iOS 16.4, *) {
                    SelectCardList(cards: qrVM.cards,
                                   selectedCard: $qrVM.selectedCard,
                                   show: $selectCard)
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(40)
                } else {
                    SelectCardList(cards: qrVM.cards,
                                   selectedCard: $qrVM.selectedCard,
                                   show: $selectCard)
                    .presentationDetents([.medium, .large])
                }
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage?.tinted(using: UIColor(red: 29/255, green: 58/255, blue: 112/255, alpha: 1)) {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct ScannedQR_Previews: PreviewProvider {
    static var previews: some View {
        ScannedQR(result: "", amount: .constant("100"), presented: .constant(false))
    }
}
