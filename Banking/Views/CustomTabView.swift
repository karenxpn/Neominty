//
//  CustomTabView.swift
//  Banking
//
//  Created by Karen Mirakyan on 14.03.23.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var router: Router
    @State private var tab: Bool = true
    
    
    var body: some View {
        Group {
            if tab {
                ZStack {
                    
                    Rectangle()
                        .fill(Color("tabBackground"))
                        .shadow(color: Color(.tabviewShadow), radius: 16, y: -12)
                    
                    HStack {
                        
                        ForEach (Tabs.allCases, id: \.self ) { tab in
                            
                            Spacer()
                            Button {
                                if router.tab == tab {
                                    if tab == .home {
                                        router.popToHomeRoot()
                                    } else if tab == .cards {
                                        router.popToCardRoot()
                                    } else if tab == .scan {
                                        router.popToScanRoot()
                                    } else if tab == .activity {
                                        router.popToAnalyticsRoot()
                                    } else if tab == .profile {
                                        router.popToAccountRoot()
                                    }
                                }
                                router.tab = tab
                            } label: {
                                VStack(spacing: 4) {
                                    
                                    Image(tab == .scan ? tab.icon : router.tab == tab ? "\(tab.icon).fill" : tab.icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(tab == .scan ? .white : router.tab == tab ? Color(.tabSelection) : Color(.appGray))
                                        .frame(width: tab == .scan ? 48 : 28, height: tab == .scan ? 48 : 28)
                                    
                                    if tab != .scan {
                                        TextHelper(text: tab.label, color: router.tab == tab ? Color(.tabSelection) : Color(.appGray))
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
