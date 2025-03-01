//
//  IntroductionPage.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    var onComplete: (() -> Void)? // Add a completion handler
    
    private let animationView = LottieAnimationView()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        animationView.play { finished in
            if finished {
                self.onComplete?()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        animationView.animation = LottieAnimation.named(name)
        animationView.play { finished in
            if finished {
                self.onComplete?()
            }
        }
    }
}


struct IntroductionPage: View {
    let introduction: IntroductionModel
    let count: Int
    @Binding var index: Int
    @State private var authenticate: Bool = false
    
    var body: some View {
        ZStack {
            
            LottieView(name: index == 0 ? "lottie-1" : "lottie-2", loopMode: .playOnce, onComplete: {
                if index == count-1 {
                    authenticate = true
                } else {
                    withAnimation {
                        index += 1
                    }
                }
            }).id(index)
                .frame(width: UIScreen.main.bounds.width * 0.6,
                       height: UIScreen.main.bounds.height * 0.4)
            
            VStack {
                Spacer()
                VStack(spacing: 16) {
                    
                    TextHelper(text: introduction.title, colorResource: .darkBlue, fontName: .bold, fontSize: 24)
                        .multilineTextAlignment(.center)
                    
                    
                    TextHelper(text: introduction.body, colorResource: .appGray)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<count, id: \.self) { ind in
                            if ind != index {
                                Circle()
                                    .fill(Color(.lightGray))
                                    .frame(width: 6, height: 6)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.darkBlue))
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
                    .shadow(color: .white, radius: 25, y: -25)
            }
        }.edgesIgnoringSafeArea(.all)
            .toolbar {
                if index != count - 1 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            authenticate = true
                        } label: {
                            TextHelper(text: NSLocalizedString("skip", comment: ""), fontName: .bold, fontSize: 16)
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
