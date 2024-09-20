//
//  AttachCardButtonLikeSelect.swift
//  Banking
//
//  Created by Karen Mirakyan on 17.05.23.
//

import SwiftUI

struct AttachCardButtonLikeSelect: View {
    let action: () -> ()

    var body: some View {
        
        Button {
            action()
        } label: {
            HStack(spacing: 19) {
                
                Image("neominty-logo")
                
                VStack(alignment: .leading, spacing: 4) {
                    TextHelper(text: NSLocalizedString("attachNewCard", comment: ""), color: AppColors.darkBlue, fontName: Roboto.medium.rawValue, fontSize: 16)
                    TextHelper(text: "**** **** **** ****", color: AppColors.appGray, fontName: Roboto.medium.rawValue, fontSize: 12)
                }
                
                Spacer()
                
                    Image("plus-without-circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 10, height: 5)
            }.padding(.vertical, 17)
                .padding(.horizontal, 20)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppColors.lightGray, lineWidth: 1)
                }
        }
    }
}

struct AttachCardButtonLikeSelect_Previews: PreviewProvider {
    static var previews: some View {
        AttachCardButtonLikeSelect(action: {
            
        })
    }
}
