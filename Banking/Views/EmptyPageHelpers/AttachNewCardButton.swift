//
//  AttachNewCardButton.swift
//  Banking
//
//  Created by Karen Mirakyan on 17.05.23.
//

import SwiftUI

struct AttachNewCardButton: View {
    
    let action: () -> ()
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(colors: [Color(.appGreen), Color(.darkBlue)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
            Image("neominty-colored")
                .padding([.bottom, .trailing], 11)
            
        }.frame(height: UIScreen.main.bounds.height * 0.23)
        .cornerRadius(16)
        .overlay {
            Button {
                action()
            } label: {

                HStack(spacing: 12) {
                    Image("plus-without-circle")

                    Text( NSLocalizedString("addNewCard", comment: "") )
                        .font(.custom(Roboto.bold.rawValue, size: 16))
                        .foregroundColor(Color(.darkBlue))

                }.frame(height: 56)
                    .padding(.horizontal, 35)
                    .background(Color(.superLightGray))
                    .cornerRadius(16)
            }
        }
        
    }
}

struct AttachNewCardButton_Previews: PreviewProvider {
    static var previews: some View {
        AttachNewCardButton(action: {
            
        })
    }
}
