//
//  CustomTabView.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var router: Router
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
                        .fill(Color("tabBackground"))
                        .shadow(color: Color(.tabviewShadow), radius: 16, y: -12)
                    
                    HStack {
                        
                        ForEach ( 0..<icons.count, id: \.self ) { id in
                            
                            Spacer()
                            Button {
                                if router.tab == id {
                                    if id == 0 {
                                        router.popToHomeRoot()
                                    } else if id == 1 {
                                        router.popToCardRoot()
                                    } else if id == 2 {
                                        router.popToScanRoot()
                                    } else if id == 3 {
                                        router.popToAnalyticsRoot()
                                    } else if id == 4 {
                                        router.popToAccountRoot()
                                    }
                                }
                                router.tab = id
                            } label: {
                                VStack(spacing: 4) {
                                    
                                    Image(id == 2 ? icons[id] : router.tab == id ? "\(icons[id]).fill" : icons[id])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(id == 2 ? .white : router.tab == id ? Color(.tabSelection) : Color(.appGray))
                                        .frame(width: 28, height: 28)
                                        .background(id == 2 ?
                                                    AnyView(Circle()
                                                        .fill(Color(.appGreen))
                                                        .frame(width: 48, height: 48)) :
                                                        AnyView(EmptyView()))
                                    
                                    
                                    if id != 2 {
                                        TextHelper(text: icon_lables[id], color: router.tab == id ? Color(.tabSelection) : Color(.appGray))
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(10)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 98)
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
            .environmentObject(Router())
    }
}
