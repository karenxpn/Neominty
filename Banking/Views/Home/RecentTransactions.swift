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
                TextHelper(text: NSLocalizedString("recentTransactions", comment: ""), color: Color(.appGray), fontName: Roboto.bold.rawValue, fontSize: 14)
                Spacer()
                
                Button {
                    action()
                } label: {
                    HStack(spacing: 0) {
                        TextHelper(text: NSLocalizedString("allTransactions", comment: ""), color: Color(.darkBlue), fontName: Roboto.medium.rawValue, fontSize: 14)
                        
                        Image("chevron-right")
                    }
                }
            }
            
            
            if transactions.isEmpty {
                NoTransactionsToShow()
            } else {
                ForEach(transactions, id: \.id) { transaction in
                    HStack(spacing: 16) {
                        
                        Image(transaction.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            TextHelper(text: transaction.name, color: Color(.darkBlue), fontName: Roboto.bold.rawValue, fontSize: 14)
                            //                        TextHelper(text: transaction.type.rawValue, color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                        }
                        
                        Spacer()
                        
                        TextHelper(text: transaction.amount, color: transaction.amount.contains(where: { $0 == "+"}) ? Color(.appGreen) : Color(.darkBlue), fontName: Roboto.bold.rawValue, fontSize: 14)
                        
                    }
                    
                    Divider()
                        .overlay(Color(.superLightGray))
                    
                }
            }

            
        }.padding(20)
            .padding(.bottom, UIScreen.main.bounds.height * 0.15)
    }
}

struct RecentTransactions_Previews: PreviewProvider {
    static var previews: some View {
        RecentTransactions(transactions: PreviewModels.transactionList) {
            
        }
    }
}
