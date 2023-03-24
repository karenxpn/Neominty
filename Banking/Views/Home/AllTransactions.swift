//
//  AllTransactions.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI

struct AllTransactions: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    let transactions: [TransactionPreviewViewModel]
    
    // add all transactions view model and get them here with pagination
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(transactions, id: \.id) { transaction in
                    HStack(spacing: 16) {
                        
                        Image(transaction.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            TextHelper(text: transaction.name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)
                            TextHelper(text: transaction.type, color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                        }
                        
                        Spacer()
                        
                        TextHelper(text: transaction.amount, color: transaction.amount.contains(where: { $0 == "+"}) ? AppColors.green : AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)
                    }
                    
                    Divider()
                        .overlay(AppColors.superLightGray)
                }
                
            }.padding(20)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.padding(.top, 1)
            .navigationTitle(Text(NSLocalizedString("allTransactions", comment: "")))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct AllTransactions_Previews: PreviewProvider {
    static var previews: some View {
        AllTransactions(transactions: PreviewModels.transactionList)
    }
}
