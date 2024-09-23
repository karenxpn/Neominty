//
//  AllTransactions.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI

struct AllTransactions: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @StateObject private var allTransferVM = AllTransferViewModel()
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                
                if allTransferVM.transfers.isEmpty && allTransferVM.alertMessage.isEmpty && !allTransferVM.loading {
                    NoTransactionsToShow()
                } else if allTransferVM.transfers.isEmpty && !allTransferVM.alertMessage.isEmpty && !allTransferVM.loading {
                    ViewFailedToLoad {
                        allTransferVM.getTransactionList()
                    }
                }
                
                ForEach(allTransferVM.transfers, id: \.id) { transfer in
                    HStack(spacing: 16) {
                        
                        Image(transfer.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            TextHelper(text: transfer.name, colorResource: .darkBlue, fontName: .bold, fontSize: 14)
//                            TextHelper(text: transfer.type.rawValue, color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)
                        }
                        
                        Spacer()
                        
                        TextHelper(text: transfer.amount, colorResource: transfer.amount.contains(where: { $0 == "+"}) ? .appGreen : .darkBlue, fontName: .bold, fontSize: 14)
                    }.onAppear {
                        if transfer.id == allTransferVM.transfers.last?.id && !allTransferVM.loading {
                            allTransferVM.getTransactionList()
                        }
                    }
                    
                    Divider()
                        .overlay(Color(.superLightGray))
                }
                
                
                if allTransferVM.loading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                
            }.padding(20)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.padding(.top, 1)
            .navigationTitle(Text(NSLocalizedString("allTransactions", comment: "")))
            .navigationBarTitleDisplayMode(.inline)
            .alert(NSLocalizedString("error", comment: ""), isPresented: $allTransferVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(allTransferVM.alertMessage)
            }).task {
                allTransferVM.getTransactionList()
            }
    }
}

struct AllTransactions_Previews: PreviewProvider {
    static var previews: some View {
        AllTransactions()
            .environmentObject(ViewRouter())
    }
}
