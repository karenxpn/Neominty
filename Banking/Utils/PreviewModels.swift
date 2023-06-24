//
//  PreviewModels.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import FirebaseFirestore

struct PreviewModels {
    static let introduction = IntroductionModel(id: "someID",
                                                image: Credentials.image,
                                                title: "Finance app the safest  and most trusted",
                                                body: "Your finance work starts here. Our here to help you track and deal with speeding up your transactions.")
    
    static let masterCard = CardModel(id: UUID().uuidString, cardPan: Credentials.masterCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .usd, bankName: "AMERIABANK", defaultCard: true, cardStyle: .signedGreenBlue, cardType: .masterCard, createdAt: Timestamp(date:Date(timeIntervalSinceNow: -1000).toGlobalTime()), bindingId: "binding1")
    static let visaCard = CardModel(id: UUID().uuidString, cardPan: Credentials.visaCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .amd, bankName: "INECOBANK", defaultCard: false, cardStyle: .standardGreen, cardType: .visa, createdAt: Timestamp(date:Date(timeIntervalSinceNow: -1000).toGlobalTime()), bindingId: "binding2")
    
    static let mirCard = CardModel(id: UUID().uuidString, cardPan: Credentials.mirCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .rub, bankName: "SBERBANK", defaultCard: false, cardStyle: .green, cardType: .mir, createdAt: Timestamp(date:Date(timeIntervalSinceNow: -1000).toGlobalTime()), bindingId: "binding3")
    
    static let amexCard = CardModel(id: UUID().uuidString, cardPan: Credentials.amexCard, cardHolder: "Tonny Monthana", expirationDate: "13/24", currency: .usd, bankName: "ACBA", defaultCard: false, cardStyle: .greenBlue, cardType: .amex, createdAt: Timestamp(date:Date(timeIntervalSinceNow: -1000).toGlobalTime()), bindingId: "binding4")
    
    static let transaction = TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString,
                                                                                   amount: 1200,
                                                                                   currency: "AMD",
                                                                                   name: "Monthly phone payment",
                                                                                   recipientInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "UCOM", paymentType: .received),
                                                                                   senderInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "Karen Mirakyan", paymentType: .phone), createdAt: Timestamp(date: Date())))
    
    
    static let transactionList = [TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString,
                                                                                        amount: 1200,
                                                                                        currency: "AMD",
                                                                                        name: "Monthly phone payment",
                                                                                        recipientInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "UCOM", paymentType: .received),
                                                                                        senderInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "Karen Mirakyan", paymentType: .phone), createdAt: Timestamp(date: Date()))),
                                  TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString,
                                                                                        amount: 1200,
                                                                                        currency: "AMD",
                                                                                        name: "Monthly phone payment",
                                                                                        recipientInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "UCOM", paymentType: .received),
                                                                                        senderInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "Karen Mirakyan", paymentType: .phone), createdAt: Timestamp(date: Date()))),
                                  TransactionPreviewViewModel(model: TransactionPreview(id: UUID().uuidString,
                                                                                        amount: 1200,
                                                                                        currency: "AMD",
                                                                                        name: "Monthly phone payment",
                                                                                        recipientInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "UCOM", paymentType: .received),
                                                                                        senderInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "Karen Mirakyan", paymentType: .phone), createdAt: Timestamp(date: Date())))]
    
    static let recentTransferList = [RecentTransfer(id: UUID().uuidString, name: "Karen Mirakyan", card: Credentials.masterCard),
                                     RecentTransfer(id: UUID().uuidString, name: "Martin Mirakyan", card: Credentials.visaCard),
                                     RecentTransfer(id: UUID().uuidString, name: "Samvel Oganisyan", card: Credentials.amexCard)]
    
    static let transactionListWithoutViewModel = [TransactionPreview(id: UUID().uuidString,
                                                                     amount: 1200,
                                                                     currency: "AMD",
                                                                     name: "Monthly phone payment",
                                                                     recipientInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "UCOM", paymentType: .received),
                                                                     senderInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "Karen Mirakyan", paymentType: .phone), createdAt: Timestamp(date: Date())), TransactionPreview(id: UUID().uuidString,
                                                                                                                                                                                                                                         amount: 1200,
                                                                                                                                                                                                                                         currency: "AMD",
                                                                                                                                                                                                                                         name: "Monthly phone payment",
                                                                                                                                                                                                                                         recipientInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "UCOM", paymentType: .received),
                                                                                                                                                                                                                                         senderInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "Karen Mirakyan", paymentType: .phone), createdAt: Timestamp(date: Date())), TransactionPreview(id: UUID().uuidString,
                                                                                                                                                                                                                                                                                                                                                                                                             amount: 1200,
                                                                                                                                                                                                                                                                                                                                                                                                             currency: "AMD",
                                                                                                                                                                                                                                                                                                                                                                                                             name: "Monthly phone payment",
                                                                                                                                                                                                                                                                                                                                                                                                             recipientInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "UCOM", paymentType: .received),
                                                                                                                                                                                                                                                                                                                                                                                                             senderInfo: TransactionParticipantInfo(id: UUID().uuidString, name: "Karen Mirakyan", paymentType: .phone), createdAt: Timestamp(date: Date()))]
    
    static let expensesPoints: [ExpensePoint] = [
        .init(amount: 989, interval: "Mon", timestamp: Timestamp(date: Date())),
        .init(amount: 989, interval: "Tue", timestamp: Timestamp(date: Date())),
        .init(amount: 989, interval: "Wed", timestamp: Timestamp(date: Date())),
        .init(amount: 989, interval: "Thu", timestamp: Timestamp(date: Date())),
        .init(amount: 989, interval: "Fri", timestamp: Timestamp(date: Date())),
        .init(amount: 989, interval: "Sat", timestamp: Timestamp(date: Date())),
        .init(amount: 989, interval: "Sun", timestamp: Timestamp(date: Date()))
]
    
    static let userInfo = UserInfoViewModel(model: UserInfo(id: UUID().uuidString, avatar: nil, name: "Karen Mirakyan", email: nil, phone_number: "+37493936313"))
    
    static let faqList = [FAQModel(id: UUID().uuidString, question: "How do I create a Neominty account?", answer: "You can create a neominty account by: download and open the neominty application first then select ..."),
                          FAQModel(id: UUID().uuidString, question: "How to create a card for Neominty?", answer: "You can select the create card menu then select 'Add New Card' select the continue button then you ..."),
                          FAQModel(id: UUID().uuidString, question: "How to Top Up on Neominty?", answer: "Click the Top Up menu then select the amount of money and the method then click the 'top up now' button...")]
    
    static let payCategories = [PayCategory(id: UUID().uuidString, title: "Phone",
                                            subCategories: [
                                                SubCategory(id: UUID().uuidString, image: "ucom", name: "Ucom", address: "Ucom address", fields: [SubcategoryField(id: UUID().uuidString, placeholder: "Phone Number", regex: "^(?:\\+?\\d{1,3})?[ -]?\\(?\\d{3}\\)?[ -]?\\d{3}[ -]?\\d{4}$", name: "phoneNumber", keyboardType: .phone)]),
                                                SubCategory(id: UUID().uuidString, image: "vivacell", name: "Vivacell MTS", address: "Vivacell MTS address", fields: [SubcategoryField(id: UUID().uuidString, placeholder: "Phone Number", regex: "^(?:\\+?\\d{1,3})?[ -]?\\(?\\d{3}\\)?[ -]?\\d{3}[ -]?\\d{4}$", name: "phoneNumber", keyboardType: .phone)]),
                                                SubCategory(id: UUID().uuidString, image: "team", name: "Team", address: "Team telecom address", fields: [SubcategoryField(id: UUID().uuidString, placeholder: "Phone Number", regex: "^(?:\\+?\\d{1,3})?[ -]?\\(?\\d{3}\\)?[ -]?\\d{3}[ -]?\\d{4}$", name: "phoneNumber", keyboardType: .phone)])]),
                                PayCategory(id: UUID().uuidString, title: "Gambling",
                                            subCategories: [
                                                SubCategory(id: UUID().uuidString, image: "toto", name: "Toto Gaming", address: "Toto Gaming Address",
                                                            fields: [SubcategoryField(id: UUID().uuidString,
                                                                                      placeholder: "Account Number",
                                                                                      regex: "^[0-9]{6,}$",
                                                                                      name: "accountNumber",
                                                                                      keyboardType: .numbers)])]),
                                PayCategory(id: UUID().uuidString, title: "ԱՊՊԱ", subCategories: [SubCategory(id: UUID().uuidString, image: "liga-insurance", name: "Liga Insurance", address: "Northern avenue 1, Yerevan",
                                                                                                            fields: [
                                                                                                                SubcategoryField(id: UUID().uuidString, placeholder: "Պետհամարանիշ", regex: "^\\d{2}[a-zA-Z]{2}\\d{3}$|^\\d{3}[a-zA-Z]{2}\\d{2}$", name: "pethamaranish", keyboardType: .keyboard),
                                                                                                                SubcategoryField(id: UUID().uuidString, placeholder: "Անձնագիր", regex: "^[A-Z]{2}\\d{7}$", name: "passport", keyboardType: .keyboard),
                                                                                                                SubcategoryField(id: UUID().uuidString, placeholder: "Հեռախոսահամար", regex: "^(?:\\+?\\d{1,3})?[ -]?\\(?\\d{3}\\)?[ -]?\\d{3}[ -]?\\d{4}$", name: "phoneNumber", keyboardType: .phone),
                                                                                                                SubcategoryField(id: UUID().uuidString, placeholder: "Էլ. փոստ", regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", name: "email", keyboardType: .keyboard)])])]
    
    static let notifications = [NotificationModel(id: UUID().uuidString,
                                                  title: "Rewards",
                                                  body: "Loyal user rewards!😘",
                                                  read: true,
                                                  created_at: Timestamp(date:Date(timeIntervalSinceNow: -1000).toGlobalTime()), type: .reward),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Money Transfer",
                                                  body: "You have successfully sent money to Maria of...",
                                                  read: false,
                                                  created_at: Timestamp(date: Date(timeIntervalSinceNow: -10000).toGlobalTime()), type: .transfer),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Payment Notification",
                                                  body: "Successfully paid!🤑",
                                                  read: false,
                                                  created_at: Timestamp(date: Date(timeIntervalSinceNow: -10023).toGlobalTime()), type: .payment),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Money Request",
                                                  body: "Your top up is successfully!",
                                                  read: true,
                                                  created_at: Timestamp(date: Date(timeIntervalSinceNow: -100000).toGlobalTime()) , type: .request),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Money Transfer",
                                                  body: "You have successfully sent money to Maria of...",
                                                  read: false,
                                                  created_at: Timestamp(date: Date(timeIntervalSinceNow: -1000002).toGlobalTime()) , type: .transfer),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Cashback 25%",
                                                  body: "You have successfully sent money to Maria of...",
                                                  read: false,
                                                  created_at: Timestamp(date: Date(timeIntervalSinceNow: -10000090).toGlobalTime()), type: .cashback),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Payment Notification",
                                                  body: "Successfully paid!🤑",
                                                  read: false,
                                                  created_at: Timestamp(date: Date(timeIntervalSinceNow: -20000090).toGlobalTime()) , type: .payment),
                                NotificationModel(id: UUID().uuidString,
                                                  title: "Unknown",
                                                  body: "Unknown type of notification",
                                                  read: false,
                                                  created_at: Timestamp(date: Date(timeIntervalSinceNow: -30000023).toGlobalTime()), type: .unknown("some unknown")),]
}
