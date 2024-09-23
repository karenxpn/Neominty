//
//  RecentTransferUsersList.swift
//  Banking
//
//  Created by Karen Mirakyan on 21.03.23.
//

import SwiftUI

struct RecentTransferUsersList: View {
    @Binding var card: String
    @Binding var selected: RecentTransfer?
    let transfers: [RecentTransfer]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(transfers, id: \.id) { transfer in
                    
                    Button {
                        if selected?.id == transfer.id {
                            selected = nil
                            card = ""
                        } else {
                            selected = transfer
                            card = transfer.card
                        }
                    } label: {
                        ZStack( alignment: .topTrailing) {
                            
                            if transfer.id == selected?.id {
                                Image("done")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(Color(.appGreen))
                                    .offset(x: -10, y: 10)
                                
                            }
                            
                            VStack(spacing: 16) {
                                if transfer.image != nil {
                                    ImageHelper(image: transfer.image!, contentMode: .fill)
                                        .frame(width: 48, height: 48)
                                        .clipShape(Circle())
                                } else {
                                    Image("anonymous-mask")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 48, height: 48)
                                        .clipShape(Circle())
                                }
                                
                                
                                TextHelper(text: transfer.name,
                                           color: Color(.darkBlue),
                                           fontName: Roboto.bold.rawValue,
                                           fontSize: 12)
                                
                            }.padding(.vertical, 26)
                                .padding(.horizontal, 25)
                        }.background {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selected?.id == transfer.id ? Color(.appGreen) : Color(.lightGray), lineWidth: 1)
                            
                        }
                    }
                }
            }

        }
    }
}

struct RecentTransferUsersList_Previews: PreviewProvider {
    static var previews: some View {
        RecentTransferUsersList(card: .constant(""), selected: .constant(nil),  transfers: PreviewModels.recentTransferList)
    }
}
