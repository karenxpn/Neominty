//
//  RecentTransactions.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct RecentTransactions: View {
    
    let transactions: [TransactionPreviewViewModel]
    let action: () -> ()
    
    var body: some View {
        LazyVStack(spacing: 16) {
            HStack {
                TextHelper(text: NSLocalizedString("recentTransactions", comment: ""), colorResource: .appGray, fontName: .bold, fontSize: 14)
                Spacer()
                
                Button {
                    action()
                } label: {
                    HStack(spacing: 0) {
                        TextHelper(text: NSLocalizedString("allTransactions", comment: ""), colorResource: .darkBlueText, fontName: .medium, fontSize: 14)
                        
                        Image("chevron-right")
                    }
                }
            }
            
            
            if transactions.isEmpty {
                NoTransactionsToShow()
            } else {
                ForEach(transactions, id: \.id) { transaction in
                    HStack(spacing: 16) {
                        
                        IconGenerator(icon: transaction.icon)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            TextHelper(text: transaction.name, colorResource: .darkBlueText, fontName: .bold, fontSize: 14)
                            //                        TextHelper(text: transaction.type.rawValue, color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                        }
                        
                        Spacer()
                        
                        TextHelper(text: transaction.amount, colorResource: transaction.amount.contains(where: { $0 == "+"}) ? .appGreen : .darkBlueText, fontName: .bold, fontSize: 14)
                        
                    }
                    
                    Divider()
                        .overlay(Color(.superLightGray))
                    
                }
            }

            
        }.padding(20)
    }
}

struct RecentTransactions_Previews: PreviewProvider {
    static var previews: some View {
        RecentTransactions(transactions: PreviewModels.transactionList) {
            
        }
    }
}
