//
//  VPOS.swift
//  Banking
//
//  Created by Karen Mirakyan on 25.04.23.
//

import SwiftUI

struct VPOS: View {
    @EnvironmentObject var cardsVM: CardsViewModel
    
    var body: some View {
        SwiftUIWebView(url: cardsVM.formURL)
    }
}

struct VPOS_Previews: PreviewProvider {
    static var previews: some View {
        VPOS()
            .environmentObject(CardsViewModel())
    }
}
