//
//  AccountViewPersonalInfo.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.04.23.
//

import SwiftUI
import SimpleToast

struct AccountViewPersonalInfo: View {
    
    @EnvironmentObject var accountVM: AccountViewModel
    @State private var showGallery: Bool = false
    @State private var selectedImage: Data?
    let info: UserInfoViewModel
    @State private var showToast: Bool = false
    
    private let toastOptions = SimpleToastOptions(
        hideAfter: 2
    )
    
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
                    HStack {
                        TextHelper(text: info.email!, color: AppColors.appGray, fontName: Roboto.regular.rawValue, fontSize: 12)
                        if !info.emailVerified {
                            Button {
                                showToast.toggle()
                            } label: {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .resizable()
                                    .foregroundStyle(.yellow)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                }
            }
        }.sheet(isPresented: $showGallery) {
            Gallery { image in
                selectedImage = image
                accountVM.updateAvatar(image: image)
            }
        }.simpleToast(isPresented: $showToast, options: toastOptions) {
            Label(
                title: { TextHelper(text: NSLocalizedString("yourEmailIsNotVerifiedYet", comment: ""), color: .black, fontName: Roboto.regular.rawValue, fontSize: 16) },
                icon: { Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                }
            )
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.superLightGray)
                    }
            }
            .shadow(radius: 10)
            .foregroundColor(Color.black)
            .cornerRadius(20)
            .padding(.top)
        }
    }
}

struct AccountViewPersonalInfo_Previews: PreviewProvider {
    static var previews: some View {
        AccountViewPersonalInfo(info: PreviewModels.userInfo)
    }
}
