//
//  AccountViewPersonalInfo.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import SwiftUI

struct AccountViewPersonalInfo: View {
    
    let info: UserInfo
    
    var body: some View {
        
        VStack(spacing: 16) {
            if info.image == nil {
                Button {
                    
                } label: {
                    ZStack {
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .shadow(color:AppColors.shadow, radius: 50, x: 5, y: 15)
                        
                        Image("plus-sign")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())

                    }
                }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                    
                    ImageHelper(image: info.image!, contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                }
            }
            
            VStack(spacing: 8) {
                TextHelper(text: info.name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                if info.email != nil {
                    TextHelper(text: info.email!, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)

                }
            }
            
        }
    }
}

struct AccountViewPersonalInfo_Previews: PreviewProvider {
    static var previews: some View {
        AccountViewPersonalInfo(info: PreviewModels.userInfo)
    }
}
