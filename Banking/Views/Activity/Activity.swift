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
    
    var body: some View {
        
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 24) {
                    
                    
                    HStack {
                        
                        HStack(spacing: 12) {
                            Image("income-icon")
                            VStack(alignment: .leading, spacing: 2) {
                                TextHelper(text: NSLocalizedString("income", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                
                                TextHelper(text: activityVM.activity.income, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)

                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Image("expense-icon")
                            VStack(alignment: .leading, spacing: 2) {
                                TextHelper(text: NSLocalizedString("expenses", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                
                                TextHelper(text: activityVM.activity.income, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)
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
                    }
                    
                    ActivityGraph(points: activityVM.activity.expensesPoints)
                    
                }.padding(24)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(AppColors.lightGray, lineWidth: 1)
                    }
                    .padding(24)
                
                
                RecentTransactions(transactions: activityVM.activity.transactions) {
                    
                }
            }.padding(.top, 1)
                .navigationBarTitle(Text(""), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextHelper(text: NSLocalizedString("transfer", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    }
                }
        }
    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        Activity()
    }
}
