//
//  Activity.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI

struct Activity: View {
    @StateObject private var activityVM = ActivityViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(AppColors.darkBlue)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(AppColors.lightGray)
    }
    
    var body: some View {
        
        NavigationStack(path: $viewRouter.analyticsPath) {
            
            ZStack {
                if activityVM.loading {
                    ProgressView()
                } else {
                    ScrollView(showsIndicators: false) {
                        
                        if !activityVM.cards.isEmpty {
                            TabView(selection: $activityVM.selectedCard) {
                                ForEach(activityVM.cards, id: \.id) { card in
                                    ActivityCard(card: card)
                                        .frame(width: UIScreen.main.bounds.width * 0.9,
                                               height: 64)
                                        .tag(card.number)
                                }
                            }.frame(height: 150)
                                .padding(.vertical, -20)
                                .tabViewStyle(.page)
                                .tabViewStyle(.page(indexDisplayMode: .always))
                                .onChange(of: activityVM.selectedCard) { newValue in
                                    activityVM.getActivity()
                                }
                        }
                        
                        VStack(spacing: 24) {
                            
                            if activityVM.loadingActivity {
                                ProgressView()
                            } else {
                                if let activity = activityVM.activity {
                                    HStack {
                                        
                                        HStack(spacing: 12) {
                                            Image("income-icon")
                                            VStack(alignment: .leading, spacing: 2) {
                                                TextHelper(text: NSLocalizedString("income", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                                
                                                TextHelper(text: activity.income, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)
                                                
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 12) {
                                            Image("expense-icon")
                                            VStack(alignment: .leading, spacing: 2) {
                                                TextHelper(text: NSLocalizedString("expenses", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                                
                                                TextHelper(text: activity.income, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)
                                            }
                                        }
                                        
                                    }.padding(.bottom, 20)
                                    
                                    HStack {
                                        ForEach(activityVM.activityUnit, id: \.self) { unit in
                                            Button {
                                                activityVM.selectedUnit = unit
                                            } label: {
                                                TextHelper(text: NSLocalizedString(unit, comment: ""), color: activityVM.selectedUnit == unit ? .black : AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 14)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background {
                                                        if activityVM.selectedUnit == unit {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(AppColors.superLightGray)
                                                        }
                                                    }
                                            }
                                        }
                                    }.onChange(of: activityVM.selectedUnit) { newValue in
                                        activityVM.getActivity()
                                    }
                                    
                                    ActivityGraph(points: activity.expensesPoints, currencySymbol: activityVM.cards.first(where: { $0.number == activityVM.selectedCard })?.currency.rawValue.currencySymbol ?? "USD".currencySymbol)
                                        .padding(.horizontal, -24)
                                }
                            }
                            
                        }
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 300,
                               maxHeight: 300)
                        .padding(24)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(AppColors.lightGray, lineWidth: 1)
                        }
                        .padding(24)
                        
                        if let transactions = activityVM.activity?.transactions {
                            RecentTransactions(transactions: transactions) {
                                viewRouter.pushAnalyicsPath(.allTransactions)
                            }
                        }
                    }.padding(.top, 1)
                    
                }
            }.navigationBarTitle(Text(""), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextHelper(text: NSLocalizedString("activity", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    }
                }.task {
                    activityVM.getCards()
                }.navigationDestination(for: AnalyticsViewPaths.self) { value in
                    switch value {
                    case .allTransactions:
                        AllTransactions()
                    }
                }
        }
    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        Activity()
            .environmentObject(ViewRouter())
    }
}
