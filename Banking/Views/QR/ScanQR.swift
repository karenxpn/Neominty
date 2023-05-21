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
                    ScannedQR(result: result, amount: $amount, presented: $presented, completed: $completed)
                        .environmentObject(qrVM)
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
