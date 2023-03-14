//
//  CustomTabView.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import SwiftUI

struct CustomTabView: View {
    let icons = ["home_icon", "card_icon", "scan_icon", "activity_icon", "profile_icon"]
    @State private var tab: Bool = true

    
    var body: some View {
        Group {
            if tab {
                ZStack {
                    
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(35, corners: [.topLeft, .topRight])
                        .shadow(radius: 2)
                    
                    HStack {
                        
                        ForEach ( 0..<icons.count, id: \.self ) { id in
                            
                            Spacer()
                            Button {
                                withAnimation {
                                    
                                }
                            } label: {
                                ZStack {
                                    
                                    if id == 2 {
                                        Circle()
                                            .fill(AppColors.green)
                                            .frame(width: 48, height: 48)
                                    }
                                    
                                    Image(icons[id])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(id == 2 ? .white : AppColors.gray)
                                        .frame(width: 28, height: 28)
                                    
                                }.padding(10)
                            }
                            
                            Spacer()
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(10)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.size.height * 0.1)
            } else {
                EmptyView()
            }
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "hideTabBar"))) { _ in
            tab = false
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "showTabBar"))) { _ in
            withAnimation {
                tab = true
            }
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
