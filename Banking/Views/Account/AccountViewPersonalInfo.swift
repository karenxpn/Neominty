//
//  AccountViewPersonalInfo.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import SwiftUI

struct AccountViewPersonalInfo: View {
    
    @EnvironmentObject var accountVM: AccountViewModel
    @State private var showGallery: Bool = false
    @State private var selectedImage: Data?
    let info: UserInfoViewModel
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            ZStack(alignment: .bottomTrailing) {
                Button {
                    showGallery.toggle()
                } label: {
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .shadow(color:AppColors.shadow, radius: 50, x: 5, y: 15)
                        
                        if info.avatar == nil && selectedImage == nil {
                            Image("plus-sign")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else if selectedImage != nil {
                            Image(uiImage: UIImage(data: selectedImage!) ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            ImageHelper(image: info.avatar!, contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        }
                    }
                }
                
                if let verified = info.isVerified {
                    Image(verified ? "user-verified" : "user-rejected")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .offset(x: -8, y: -8)
                }
            }
            
            
            VStack(spacing: 8) {
                if info.name != nil {
                    TextHelper(text: info.name!, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
                
                if info.email != nil {
                    TextHelper(text: info.email!, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                }
            }
        }.sheet(isPresented: $showGallery) {
            Gallery { image in
                selectedImage = image
                accountVM.updateAvatar(image: image)
            }
        }
    }
}

struct AccountViewPersonalInfo_Previews: PreviewProvider {
    static var previews: some View {
        AccountViewPersonalInfo(info: PreviewModels.userInfo)
    }
}
