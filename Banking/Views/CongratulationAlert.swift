//
//  CongratulationAlert.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct CongratulationAlert<Content: View>: View {
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
            
            Color(.darkBlue).opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            

            ZStack(alignment: .top) {
                
                Image("congrat-alert-pattern")
                    .offset(y: -100)

                GifImageView("coins-hover")
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
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
                TextHelper(text: NSLocalizedString("cardIsReady", comment: ""), colorResource: .darkBlue, fontName: .bold, fontSize: 20)
                
                TextHelper(text: NSLocalizedString("cardIsReadyMessage", comment: ""), colorResource: .appGray, fontSize: 12)
            }
        }, action: {
            
        })
    }
}
