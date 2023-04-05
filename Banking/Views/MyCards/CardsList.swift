//
//  CardsList.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct CardsList: View {
    @EnvironmentObject var viewRouter: ViewRouter
    let cards: [CardModel]
    var body: some View {
        
        List {
            ForEach(cards, id: \.id) { card in
                UserCard(card: card, selected: false)
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        Button {
                            print("pressed")
                        } label: {
                            Image("delete-card")
                                .padding(.vertical, 29)
                                .padding(.horizontal, 18)
                                .background(AppColors.green)
                                .cornerRadius(16)
                        }.tint(.clear)
                    }
            }
            
            Button {
                viewRouter.pushCardPath(.attachCard)
            } label: {
                
                HStack(spacing: 12) {
                    Spacer()
                    
                    Image("plus-without-circle")
                    
                    Text( NSLocalizedString("addNewCard", comment: "") )
                        .font(.custom(Roboto.bold.rawValue, size: 16))
                        .foregroundColor(AppColors.darkBlue)
                    
                    Spacer()
                }.frame(height: 56)
                .background(AppColors.superLightGray)
                    .cornerRadius(16)
                
            }.buttonStyle(.plain)
            
            Spacer()
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
                .listRowSeparator(.hidden)
            
        }.listStyle(.plain)
            .padding(.top, 1)
    }
}

struct CardsList_Previews: PreviewProvider {
    static var previews: some View {
        CardsList(cards: [PreviewModels.visaCard, PreviewModels.masterCard])
    }
}
