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
    
    static let masterCard = CardModel(id: UUID().uuidString, number: Credentials.masterCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .usd, bankName: "AMERIABANK", defaultCard: true, design: .blueGreen, cardType: .masterCard)
    static let visaCard = CardModel(id: UUID().uuidString, number: Credentials.visaCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .amd, bankName: "INECOBANK", defaultCard: false, design: .blue, cardType: .visa)
    
    static let mirCard = CardModel(id: UUID().uuidString, number: Credentials.mirCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .rub, bankName: "SBERBANK", defaultCard: false, design: .green, cardType: .mir)
    
    static let amexCard = CardModel(id: UUID().uuidString, number: Credentials.amexCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .usd, bankName: "ACBA", defaultCard: false, design: .greenBlue, cardType: .amex)
    
    static let transaction = TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "gym", name: "Gym", type: "Payment", amount: -15.99))
    static let transactionList = [TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "gym", name: "Gym", type: "Payment", amount: -15.99)),
                                  TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "deposite", name: "Bank of America", type: "Deposit", amount: +2045.00)),
                                  TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString, icon: "sent", name: "To Brody Armando", type: "Sent", amount: -699.00))]
    
    static let recentTransferList = [RecentTransfer(id: UUID().uuidString, name: "Karen Mirakyan", card: Credentials.masterCard),
                                     RecentTransfer(id: UUID().uuidString, name: "Martin Mirakyan", card: Credentials.visaCard),
                                     RecentTransfer(id: UUID().uuidString, name: "Samvel Oganisyan", card: Credentials.amexCard)]
    
    static let transactionListWithoutViewModel = [TransactionPreview(id: UUID().uuidString, icon: "gym", name: "Gym", type: "Payment", amount: -15.99), TransactionPreview(id: UUID().uuidString, icon: "deposite", name: "Bank of America", type: "Deposit", amount: +2045.00), TransactionPreview(id: UUID().uuidString, icon: "sent", name: "To Brody Armando", type: "Sent", amount: -699.00)]
    
    static let expensesPoints: [ExpensePoint] = [
        .init(unit: "Mon", amount: 989),
        .init(unit: "Tue", amount: 1200),
        .init(unit: "Wed", amount: 750),
        .init(unit: "Thu", amount: 650),
        .init(unit: "Fri", amount: 950),
        .init(unit: "Sat", amount: 650),
        .init(unit: "Sun", amount: 1200)]
    
    static let userInfo = UserInfoViewModel(model: UserInfo(image: nil, name: "Karen Mirakyan", email: nil, phoneNumber: PhoneModel(code: "AM", number: "93936313")))
}
