//
//  AccountVerificationApproved.swift
//  Banking
//
//  Created by Karen Mirakyan on 12.10.23.
//

import SwiftUI

struct AccountVerificationApproved: View {
    @State private var animate = false

    var body: some View {
        
        ScrollView(showsIndicators: false, content: {
            VStack(spacing: 50) {
                Spacer(minLength: UIScreen.main.bounds.height * 0.1)
                    
                if #available(iOS 17.0, *) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundStyle(AppColors.green)
                        .symbolEffect(.bounce, options: .nonRepeating, value: animate)
                        .frame(width: 200, height: 200)
                } else {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundStyle(AppColors.green)
                        .frame(width: 200, height: 200)
                }
                
                VStack(spacing: 12) {
                    TextHelper(text: NSLocalizedString("congratulations", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    
                    TextHelper(text: NSLocalizedString("yourAccountIsVerified", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 16)
                        .multilineTextAlignment(.center)
                }
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            ).padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }).padding(.top, 1)
            .onAppear {
                animate.toggle()
            }
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("verificationStatus", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }
    }
}

#Preview {
    AccountVerificationApproved()
}
