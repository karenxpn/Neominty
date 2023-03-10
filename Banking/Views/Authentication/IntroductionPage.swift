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

                    Text(introduction.title)
                        .foregroundColor(AppColors.darkBlue)
                        .font(.custom("Roboto", size: 24))
                        .fontWeight(.heavy)
                        .kerning(0.3)
                        .multilineTextAlignment(.center)
                    
                    
                    Text(introduction.body)
                        .foregroundColor(.gray)
                        .font(.custom("Roboto", size: 11))
                        .fontWeight(.regular)
                        .kerning(0.3)
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
                    // carousel
                    
                    ButtonHelper(disabled: false, label: index == count-1 ? NSLocalizedString("getStarted", comment: "") : NSLocalizedString("next", comment: "")) {
                        if index == count-1 {
                            authenticate = true
                        } else {
                            withAnimation {
                                index += 1
                            }
                        }
                    }.padding(.top, 18)
                        .navigationDestination(isPresented: $authenticate) {
                            Authentication()
                        }
                    
                    
                }.padding(45)
                    .background(Color.white)
            }
        }.edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authenticate = true
                    } label: {
                        Text(NSLocalizedString("skip", comment: ""))
                            .foregroundColor(.black)
                    }.navigationDestination(isPresented: $authenticate) {
                        Authentication()
                    }

                }
            }
    }
}

struct IntroductionPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionPage(introduction: PreviewModels.introduction, count: 2, index: .constant(0))
    }
}
