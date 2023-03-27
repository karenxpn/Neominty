//
//  CongratulationAlert.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct CongratulationAlert<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    private var content: Content

    
    init( @ViewBuilder content: () -> Content) {
        UITableView.appearance().backgroundColor = .clear
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            
            BackgroundBlurView()
                .edgesIgnoringSafeArea(.all)
            
            AppColors.darkBlue.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            

            ZStack(alignment: .top) {
                
                Image("congrat-alert-pattern")
                    .offset(y: -100)


                Image("alert-card")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88)
                    .offset(y: -50)
                
                VStack( spacing: 15) {
                    
                    content
                        .padding(.top, 40)
                    
                    
                    ButtonHelper(disabled: false, label: NSLocalizedString("okIamReady", comment: "")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                }.padding(24)
                    .background {

                        Color.white.clipShape(AlertShape())
                            .cornerRadius(24)
                    }
            }.padding(24)
            
        }.onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CongratulationAlert_Previews: PreviewProvider {
    static var previews: some View {
        CongratulationAlert(content: {
            
            VStack(spacing: 12) {
                TextHelper(text: NSLocalizedString("cardIsReady", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                
                TextHelper(text: NSLocalizedString("cardIsReadyMessage", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                
            }
        })
    }
}
