//
//  CustomTabView.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    let icons = ["home_icon", "card_icon", "scan_icon", "activity_icon", "profile_icon"]
    let icon_lables = [NSLocalizedString("home", comment: ""),
                       NSLocalizedString("myCard", comment: ""),
                       NSLocalizedString("", comment: ""),
                       NSLocalizedString("activity", comment: ""),
                       NSLocalizedString("profile", comment: "")]
    @State private var tab: Bool = true
    
    
    var body: some View {
        Group {
            if tab {
                ZStack {
                    
                    Rectangle()
                        .fill(.white)
                        .shadow(color: AppColors.shadow, radius: 16, y: -12)
                    
                    HStack {
                        
                        ForEach ( 0..<icons.count, id: \.self ) { id in
                            
                            Spacer()
                            Button {
                                withAnimation {
                                    viewRouter.tab = id
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    
                                    Image(icons[id])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(id == 2 ? .white : viewRouter.tab == id ? AppColors.darkBlue : AppColors.gray)
                                        .frame(width: 28, height: 28)
                                        .background(id == 2 ?
                                                    AnyView(Circle()
                                                        .fill(AppColors.green)
                                                        .frame(width: 48, height: 48)) :
                                                        AnyView(EmptyView()))
                                    
                                    
                                    if id != 2 {
                                        TextHelper(text: icon_lables[id], color: viewRouter.tab == id ? AppColors.darkBlue : AppColors.gray)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(10)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 64)
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
            .environmentObject(ViewRouter())
    }
}
