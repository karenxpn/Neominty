//
//  ScanQR.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.04.23.
//

import SwiftUI
import CodeScanner

struct ScanQR: View {
    @Binding var presented: Bool
    @State private var result: String?
    
    var body: some View {
        ZStack(alignment: .topTrailing, content: {
            
            if let result {
                Text(result)
            } else {
                CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "Paul Hudson") { response in
                    switch response {
                    case .success(let result):
                        self.result = result.string
                        print("Found code: \(result.string)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button {
                presented.toggle()
            } label: {
                Text("XXX")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding(24)
            }
        })
    }
}

struct ScanQR_Previews: PreviewProvider {
    static var previews: some View {
        ScanQR(presented: .constant(false))
    }
}
