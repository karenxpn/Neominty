//
//  Loading.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI

struct Loading<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack(spacing: 10) {
                    ProgressView()
                        .scaleEffect(1.5)
                    TextHelper(text: NSLocalizedString("loading", comment: ""), fontSize: 18)
                }
                .frame(width: geometry.size.width / 2.5,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading(isShowing: .constant(true)) {
            EmptyView()
        }
    }
}
