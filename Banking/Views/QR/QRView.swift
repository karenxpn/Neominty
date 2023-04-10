//
//  QRView.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.04.23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct QRView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var qrVM = QrViewModel()
    @State private var selectCard: Bool = false
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    
    var body: some View {
        NavigationStack(path: $viewRouter.scanPath) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 60) {
                    
                    if qrVM.loading {
                        ProgressView()
                    } else {
                        
                        if qrVM.selectedCard != nil {
                            SelectCardButton(card: qrVM.selectedCard!, buttonType: .popup) {
                                selectCard.toggle()
                            }
                            
                            Image(uiImage: generateQRCode(from: "\(qrVM.selectedCard!.number)"))
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 210, height: 210)
                                .padding(.horizontal, 47)
                                .padding(.vertical, 57)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: AppColors.shadow, radius: 25, x: 2, y: 15)
                        }
                        
                        ButtonHelper(disabled: qrVM.selectedCard == nil, label: NSLocalizedString("scanQR", comment: "")) {
                            
                        }
                    }
                    
                    
                }.padding(24)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            }.padding(.top, 1)
                .navigationTitle(Text(""))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            TextHelper(text: NSLocalizedString("showQrCode", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                        }
                    }.task {
                        qrVM.getCards()
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

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
            .environmentObject(ViewRouter())
    }
}
