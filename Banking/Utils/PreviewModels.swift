//
//  PreviewModels.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
struct PreviewModels {
    static let introduction = IntroductionModel(id: "someID",
                                                image: Credentials.image,
                                                title: "Finance app the safest  and most trusted",
                                                body: "Your finance work starts here. Our here to help you track and deal with speeding up your transactions.")
    
    static let masterCard = CardModel(id: UUID().uuidString, number: "5242 4242 4242 4242", cardHolder: "Tonny Monthana", expirationDate: "13/24", defaultCard: true, design: .blueGreen, cardType: .masterCard)
    static let visaCard = CardModel(id: UUID().uuidString, number: "4242 4242 4242 4242", cardHolder: "Tonny Monthana", expirationDate: "13/24", defaultCard: false, design: .blue, cardType: .visa)
    
    static let mirCard = CardModel(id: UUID().uuidString, number: "2242 4242 4242 4242", cardHolder: "Tonny Monthana", expirationDate: "13/24", defaultCard: false, design: .green, cardType: .mir)
    
    static let arcaCard = CardModel(id: UUID().uuidString, number: "2242 4242 4242 4242", cardHolder: "Tonny Monthana", expirationDate: "13/24", defaultCard: false, design: .greenBlue, cardType: .arca)
    
    static let transaction = TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "gym", name: "Gym", type: "Payment", amount: -15.99))
    static let transactionList = [TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "gym", name: "Gym", type: "Payment", amount: -15.99)),
                                  TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "deposite", name: "Bank of America", type: "Deposit", amount: +2045.00)),
                                  TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "sent", name: "To Brody Armando", type: "Sent", amount: -699.00))]
    
    static let recentTransferList = [RecentTransfer(id: UUID().uuidString, name: "Karen Mirakyan", card: Credentials.validCard),
                                     RecentTransfer(id: UUID().uuidString, name: "Martin Mirakyan", card: "2242 4242 4242 4242"),
                                     RecentTransfer(id: UUID().uuidString, name: "Samvel Oganisyan", card: "5242 4242 4242 4242")]
    
    static let transactionListWithoutViewModel = [TransactionPreview(id: UUID().uuidString, icon: "gym", name: "Gym", type: "Payment", amount: -15.99), TransactionPreview(id: UUID().uuidString, icon: "deposite", name: "Bank of America", type: "Deposit", amount: +2045.00), TransactionPreview(id: UUID().uuidString, icon: "sent", name: "To Brody Armando", type: "Sent", amount: -699.00)]
    
    static let expensesPoints: [ExpensePoint] = [
        .init(unit: "Mon", amount: 989),
        .init(unit: "Tue", amount: 1200),
        .init(unit: "Wed", amount: 750),
        .init(unit: "Thu", amount: 650),
        .init(unit: "Fri", amount: 950),
        .init(unit: "Sat", amount: 650),
        .init(unit: "Sun", amount: 1200)]
}
