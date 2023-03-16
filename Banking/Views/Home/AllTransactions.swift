//
//  AllTransactions.swift
//  Banking
//
//  Created by Karen Mirakyan on 16.03.23.
//

import SwiftUI

struct AllTransactions: View {
    @EnvironmentObject private var viewRouter: ViewRouter

    var body: some View {
        Text("All Transactions")
    }
}

struct AllTransactions_Previews: PreviewProvider {
    static var previews: some View {
        AllTransactions()
    }
}
