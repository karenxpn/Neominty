//
//  RequestTypeList.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import SwiftUI

struct RequestTypeList: View {
    @Binding var selected: RequestType
    let types: [RequestType] = [.phone, .email, .link]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(types, id: \.id) { type in
                Button {
                    selected = type
                } label: {
                    Image(type.image)
                        .padding(.vertical, 9)
                        .padding(.horizontal, 40)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(type.id == selected.id ? AppColors.green : AppColors.lightGray)
                        }
                }
            }
        }
    }
}

struct RequestTypeList_Previews: PreviewProvider {
    static var previews: some View {
        RequestTypeList(selected: .constant(.email))
    }
}
