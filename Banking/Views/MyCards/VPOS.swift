//
//  VPOS.swift
//  Banking
//
//  Created by Karen Mirakyan on 25.04.23.
//

import SwiftUI

struct VPOS: View {
    @Binding var active: Bool
    @EnvironmentObject var cardsVM: CardsViewModel
    
    var body: some View {
        SwiftUIWebView(url: cardsVM.formURL, active: $active)
            .environmentObject(cardsVM)
    }
}

struct VPOS_Previews: PreviewProvider {
    static var previews: some View {
        VPOS(active: .constant(false))
            .environmentObject(CardsViewModel())
    }
}
