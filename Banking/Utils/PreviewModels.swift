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
    
    static let faqList = [FAQModel(id: UUID().uuidString, question: "How do I create a Neominty account?", answer: "You can create a neominty account by: download and open the neominty application first then select ..."),
                          FAQModel(id: UUID().uuidString, question: "How to create a card for Neominty?", answer: "You can select the create card menu then select 'Add New Card' select the continue button then you ..."),
                          FAQModel(id: UUID().uuidString, question: "How to Top Up on Neominty?", answer: "Click the Top Up menu then select the amount of money and the method then click the 'top up now' button...")]
    
    static let payCategories = [PayCategory(id: UUID().uuidString, title: "Phone", subCategory: [SubCategory(id: UUID().uuidString, image: "ucom", name: "Ucom", address: "Ucom address"),
                                                                                                 SubCategory(id: UUID().uuidString, image: "vivacell", name: "Vivacell MTS", address: "Vivacell MTS address"),
                                                                                                 SubCategory(id: UUID().uuidString, image: "team", name: "Team", address: "Team telecom address")]),
                                PayCategory(id: UUID().uuidString, title: "Gambling", subCategory: [SubCategory(id: UUID().uuidString, image: "toto", name: "Toto Gaming", address: "Toto Gaming Address")])]
    
    static let notifications = [NotificationModel(id: UUID().uuidString,
                                                  title: "Rewards",
                                                  body: "Loyal user rewards!😘",
                                                  read: true,
                                                  createdAt: Date(timeIntervalSinceNow: -1000), type: .reward),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Money Transfer",
                                                  body: "You have successfully sent money to Maria of...",
                                                  read: false,
                                                  createdAt: Date(timeIntervalSinceNow: -10000), type: .transfer),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Payment Notification",
                                                  body: "Successfully paid!🤑",
                                                  read: false,
                                                  createdAt: Date(timeIntervalSinceNow: -10023), type: .payment),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Money Request",
                                                  body: "Your top up is successfully!",
                                                  read: true,
                                                  createdAt: Date(timeIntervalSinceNow: -100000), type: .request),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Money Transfer",
                                                  body: "You have successfully sent money to Maria of...",
                                                  read: false,
                                                  createdAt: Date(timeIntervalSinceNow: -1000002), type: .transfer),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Cashback 25%",
                                                  body: "You have successfully sent money to Maria of...",
                                                  read: false,
                                                  createdAt: Date(timeIntervalSinceNow: -10000090), type: .cashback),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Payment Notification",
                                                  body: "Successfully paid!🤑",
                                                  read: false,
                                                  createdAt: Date(timeIntervalSinceNow: -20000090), type: .payment),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Unknown",
                                                  body: "Unknown type of notification",
                                                  read: false,
                                                  createdAt: Date(timeIntervalSinceNow: -30000023), type: .unknown("some unknown")),]
}
