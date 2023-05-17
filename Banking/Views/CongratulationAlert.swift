//
//  CongratulationAlert.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct CongratulationAlert<Content: View>: View {
    @EnvironmentObject var viewRouter: ViewRouter
    private var content: Content
    private var action: () -> ()

    
    init( @ViewBuilder content: () -> Content, action: @escaping () -> () ) {
        UITableView.appearance().backgroundColor = .clear
        self.content = content()
        self.action = action
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
                        action()
                    }
                    
                }.padding(24)
                    .background {

                        Color.white.clipShape(AlertShape())
                            .cornerRadius(24)
                    }
            }.padding(24)
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
        }, action: {
            
        })
    }
}
