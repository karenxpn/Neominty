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

}
