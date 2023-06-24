//
//  CardsList.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct CardsList: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var cardsVM: CardsViewModel
    let cards: [CardModel]
    @Binding var loading: Bool
    @State private var selectedToDelete: CardModel?
    @State private var showConfirmationDialog: Bool = false
    
    var body: some View {
        
        List {
            ForEach(cards, id: \.id) { card in
                UserCard(card: card, selected: false)
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        if !card.defaultCard && !loading {
                            Button {
                                selectedToDelete = card
                                showConfirmationDialog.toggle()
                            } label: {
                                Image("delete-card")
                                    .padding(.vertical, 29)
                                    .padding(.horizontal, 18)
                                    .background(AppColors.green)
                                    .cornerRadius(16)
                            }.tint(.clear)
                        }
                    }
            }.onMove(perform: move)

            
            if !loading {
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
            }
            
            Spacer()
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
                .listRowSeparator(.hidden)
            
        }.listStyle(.plain)
            .padding(.top, 1)
            .alert(NSLocalizedString("areYourSureToDeleteTheCard", comment: ""), isPresented: $showConfirmationDialog) {
                Button(NSLocalizedString("delete", comment: "")) {
                    // delete
                    if let selectedToDelete, let id = selectedToDelete.id{
                        cardsVM.deleteCard(id: id)
                    }
                }
                
                Button(role: .cancel) {
                    selectedToDelete = nil
                } label: {
                    Text(NSLocalizedString("cancel", comment: ""))
                }

            } message: {
                Text(NSLocalizedString("deleteCardMessage", comment: ""))
            }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        if !loading {
            cardsVM.cards.move(fromOffsets: source, toOffset: destination)
            cardsVM.reorderCards()
        }
    }
}

struct CardsList_Previews: PreviewProvider {
    static var previews: some View {
        CardsList(cards: [PreviewModels.visaCard, PreviewModels.masterCard], loading: .constant(false))
    }
}
