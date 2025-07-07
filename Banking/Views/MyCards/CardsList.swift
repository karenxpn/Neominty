//
//  CardsList.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import SwiftUI

struct CardsList: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var cardsVM: CardsViewModel
    let cards: [CardModel]
    @Binding var loading: Bool
    @State private var selectedToDelete: CardModel?
    @State private var showConfirmationDialog: Bool = false
    
    var body: some View {
        
        List {
            ForEach(cards, id: \.id) { card in
                UserCard(card: card, selected: false)
                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 16))
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
                                    .background(Color(.appGreen))
                                    .cornerRadius(16)
                            }.tint(.clear)
                        }
                    }
            }.onMove(perform: move)
                .moveDisabled(loading)

            
            if !loading {
                Button {
                    router.pushCardPath(.selectNewCardStyle)
                } label: {
                    
                    HStack(spacing: 12) {
                        Spacer()
                        
                        Image("plus-without-circle")
                        
                        Text( String(localized: .addNewCard) )
                            .font(.custom(Roboto.bold.rawValue, size: 16))
                            .foregroundColor(Color(.darkBlue))
                        
                        Spacer()
                    }.frame(height: 56)
                        .background(Color(.superLightGray))
                        .cornerRadius(16)
                    
                }.buttonStyle(.plain)
                    .listRowSeparator(.hidden)
            }
                        
        }.listStyle(.plain)
            .padding(.top, 1)
            .alert(String(localized: .areYourSureToDeleteTheCard), isPresented: $showConfirmationDialog) {
                Button(String(localized: .delete)) {
                    // delete
                    if let selectedToDelete, let id = selectedToDelete.id{
                        cardsVM.deleteCard(id: id)
                    }
                }
                
                Button(role: .cancel) {
                    selectedToDelete = nil
                } label: {
                    Text(String(localized: .cancel))
                }

            } message: {
                Text(String(localized: .deleteCardMessage))
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
