//
//  RecentTransactions.swift
//  Banking
//
//  Created by Karen Mirakyan on 19.03.23.
//

import SwiftUI

struct RecentTransactions: View {
    
    @Binding var loading: Bool
    let transactions: [TransactionPreviewViewModel]
    let action: () -> ()
    
    var body: some View {
        LazyVStack(spacing: 16) {
            HStack {
                TextHelper(text: NSLocalizedString("recentTransactions", comment: ""), color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 14)
                Spacer()
                
                Button {
                    action()
                } label: {
                    HStack(spacing: 0) {
                        TextHelper(text: NSLocalizedString("allTransactions", comment: ""), color: AppColors.darkBlue, fontName: Roboto.medium.rawValue, fontSize: 14)
                        
                        Image("chevron-right")
                    }
                }
            }
            
            ForEach(transactions, id: \.id) { transaction in
                HStack(spacing: 16) {
                    
                    Image(transaction.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextHelper(text: transaction.name, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)
//                        TextHelper(text: transaction.type.rawValue, color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                    }
                    
                    Spacer()
                    
                    TextHelper(text: transaction.amount, color: transaction.amount.contains(where: { $0 == "+"}) ? AppColors.green : AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 14)

                }
                
                Divider()
                    .overlay(AppColors.superLightGray)

            }
            
            if loading {
                ProgressView()
            }
            
        }.padding(20)
            .padding(.bottom, UIScreen.main.bounds.height * 0.15)
    }
}

struct RecentTransactions_Previews: PreviewProvider {
    static var previews: some View {
        RecentTransactions(loading: .constant(false), transactions: PreviewModels.transactionList) {
            
        }
    }
}
