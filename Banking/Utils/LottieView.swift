//
//  LottieView.swift
//  Banking
//
//  Created by Karen Mirakyan on 01.03.25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    var onComplete: (() -> Void)?
    
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
