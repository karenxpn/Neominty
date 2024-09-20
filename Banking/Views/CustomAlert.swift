//
//  CustomAlert.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//


import SwiftUI

struct CustomAlert<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    private var content: Content
    let action: () -> ()

    
    init( @ViewBuilder content: () -> Content, action: @escaping () -> ()) {
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
                Image("alert-card")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88)
                    .offset(y: -50)
                
                VStack( spacing: 15) {
                    
                    content
                        .padding(.top, 40)
                    
                    
                    ButtonHelper(disabled: false, label: NSLocalizedString("okSendNow", comment: "")) {
                        action()
                    }
                    
                    
                }.padding(24)
                    .background {

                        Color.white.clipShape(AlertShape())
                            .cornerRadius(24)
                    }
            }.padding(24)
            
        }.onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "transferSuccess"))) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(content: {
            
            VStack(spacing: 31) {
                TextHelper(text: "Transfer Confirmation", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                
                
                VStack(spacing: 8) {
                    HStack {
                        TextHelper(text: "From", color: AppColors.appGray, fontName: Roboto.regular.rawValue, fontSize: 12)
                        Spacer()
                        TextHelper(text: "Bank of America", color: AppColors.appGray, fontName: Roboto.regular.rawValue, fontSize: 12)
                    }
                    
                    HStack {
                        TextHelper(text: "Tonny Monthana", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                        Spacer()
                        TextHelper(text: "**** 1121", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                    }
                    
                    Divider()
                        .padding(.top)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        TextHelper(text: "To", color: AppColors.appGray, fontName: Roboto.regular.rawValue, fontSize: 12)
                        Spacer()
                        TextHelper(text: "Citibank Online", color: AppColors.appGray, fontName: Roboto.regular.rawValue, fontSize: 12)
                    }
                    
                    HStack {
                        TextHelper(text: "Linda", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                        Spacer()
                        TextHelper(text: "**** 8456", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                    }
                    
                    Divider()
                        .padding(.top)
                }
                
                HStack {
                    TextHelper(text: "Total", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                    Spacer()
                    TextHelper(text: "$868.10", color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 16)
                }
                
            }
            
        }, action: {
            
        })
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct AlertShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = rect.width / 2
            path.move(to: CGPoint(x: center-65, y: 0))
            
            let to1 = CGPoint(x: center, y: 45)
            let control1 = CGPoint(x: center - 45, y: 0)
            let control2 = CGPoint(x: center - 45, y: 45)
            
            let to2 = CGPoint(x: center + 65, y: 0)
            let control3 = CGPoint(x: center + 45, y: 45)
            let control4 = CGPoint(x: center + 45, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)

        }
    }
}
