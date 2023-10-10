//
//  IntroductionPage.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

struct IntroductionPage: View {
    let introduction: IntroductionModel
    let count: Int
    @Binding var index: Int
    @State private var authenticate: Bool = false
    
    var body: some View {
        ZStack {
            
            ImageHelper(image: introduction.image,
                        contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width * 0.6,
                   height: UIScreen.main.bounds.height * 0.5)
            
            VStack {
                Spacer()
                VStack(spacing: 16) {

                    TextHelper(text: introduction.title, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                        .multilineTextAlignment(.center)
                    
                    
                    TextHelper(text: introduction.body, color: AppColors.gray)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 4) {
                        ForEach(0..<count, id: \.self) { ind in
                            if ind != index {
                                Circle()
                                    .fill(AppColors.lightGray)
                                    .frame(width: 6, height: 6)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(AppColors.darkBlue)
                                    .frame(width: 32, height: 6)
                            }
                        }
                    }.padding(.top, 29)
                        .zIndex(10)
                    // carousel
                    
                    ButtonHelper(disabled: false, label: index == count-1 ?
                                 NSLocalizedString("getStarted", comment: "") :
                                    NSLocalizedString("next", comment: "")) {
                        if index == count-1 {
                            authenticate = true
                        } else {
                            withAnimation {
                                index += 1
                            }
                        }
                    }.padding(.top, 18)
                    
                }.padding(45)
                    .background(Color.white)
                    .shadow(color: .white, radius: 25, y: -50)
            }
        }.edgesIgnoringSafeArea(.all)
            .toolbar {
                if index != count - 1 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            authenticate = true
                        } label: {
                            TextHelper(text: NSLocalizedString("skip", comment: ""), fontName: Roboto.bold.rawValue, fontSize: 16)
                        }                        
                    }
                }
            }.navigationDestination(isPresented: $authenticate) {
                PhoneAuthentication()
            }
    }
}

struct IntroductionPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionPage(introduction: PreviewModels.introduction, count: 2, index: .constant(0))
    }
}
