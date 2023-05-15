//
//  ScanQR.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.04.23.
//

import SwiftUI
import CodeScanner

struct ScanQR: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var qrVM = QrViewModel()
    @Binding var presented: Bool
    
    @State private var result: String?
    @State private var amount: String = ""
    @State private var completed: Bool = false
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing, content: {
                
                if let result {

                    AppColors.darkGray
                        .edgesIgnoringSafeArea(.all)
                    
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
                                .shadow(color: AppColors.shadow, radius: 25, x: 2, y: 15)
                            
                            Image("scan-success")
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
                                
                                AmountTextField(text: $amount, fontSize: 24)
                                
                            }.padding([.horizontal, .bottom], 16)
                        }.background {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(AppColors.lightGray, lineWidth: 1)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                }
                        }
                        
                        ButtonHelper(disabled: amount.isEmpty || qrVM.loading,
                                     label: qrVM.loading ? NSLocalizedString("pleaseWait", comment: "") : NSLocalizedString("sendMoney", comment: "")) {
                            qrVM.performPayment(account: result, amount: amount)
                        }.navigationDestination(isPresented: $completed) {
                            TransferSuccess(amount: amount, currency: .usd) {
                                presented.toggle()
                                viewRouter.popToScanRoot()
                            }
                        }
                        
                    }.padding(24)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    
                    
                } else {
                    CodeScannerView(codeTypes: [.qr], scanMode: .continuous, showViewfinder: true, simulatedData: "Paul Hudson") { response in
                        switch response {
                        case .success(let result):
                            if result.string.isQrValid() {
                                self.result = result.string
                            } else {
                                qrVM.showAlert.toggle()
                                qrVM.alertMessage = NSLocalizedString("notValidQR", comment: "")
                            }
                        case .failure(let error):
                            qrVM.showAlert.toggle()
                            qrVM.alertMessage = error.localizedDescription
                        }
                    }
                }
                
                Button {
                    presented.toggle()
                } label: {
                    Image("close-scan")
                        .padding(24)
                }
            }).gesture(DragGesture().onChanged({ _ in
                UIApplication.shared.endEditing()
            })).onReceive(NotificationCenter
                .default
                .publisher(for:Notification.Name(rawValue: NotificationName.paymentCompleted.rawValue))) { _ in
                    completed.toggle()
                }.alert(NSLocalizedString("error", comment: ""), isPresented: $qrVM.showAlert, actions: {
                    Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
                }, message: {
                    Text(qrVM.alertMessage)
                }).toolbar(.hidden, for: .navigationBar)
                .navigationTitle(Text(""))
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

struct ScanQR_Previews: PreviewProvider {
    static var previews: some View {
        ScanQR(presented: .constant(false))
    }
}
