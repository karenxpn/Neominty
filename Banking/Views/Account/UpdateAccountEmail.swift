//
//  UpdateAccountEmail.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.10.23.
//

import SwiftUI

struct UpdateAccountEmail: View {
    @State private var email: String
    @State private var emailValid: Bool
    @StateObject private var accountVM = AccountViewModel()
    @EnvironmentObject var router: Router
    
    
    init(email: String?) {
        _email = State(initialValue: email ?? "")
        _emailValid = State(initialValue: email?.isEmail ?? true)
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            TextHelper(text: String(localized: .email), colorResource: .appGray, fontName: .bold, fontSize: 16)
            
            CardDetailTextFieldDecorator(content: {
                TextField(String(localized: .exampleDomainCom), text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .font(.custom(Roboto.medium.rawValue, size: 16))
                    .padding(.leading, 16)
                    .onChange(of: email) { _, newValue in
                        emailValid = newValue.isEmail
                    }
            }, isValid: $emailValid)
            
            TextHelper(text: String(localized: .youWillReceiveVerificationEmail), colorResource: .appGray)
            
            
            ButtonHelper(disabled: !emailValid || (emailValid && email.isEmpty) || accountVM.loading, label: String(localized: .update)) {
                accountVM.updateEmail(email: email)
            }.padding(.top, 100)
            
            
        }.padding(24)
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(Text(""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextHelper(text: String(localized: .verifyYourEmail), colorResource: .darkBlueText, fontName: .bold, fontSize: 20)
                    }
                }.onReceive(NotificationCenter.default.publisher(for:
                                                                    Notification.Name(rawValue: NotificationName.emailUpdated.rawValue))) { _ in
                    router.popToAccountRoot()
                }.alert(String(localized: .error), isPresented: $accountVM.showAlert, actions: {
                    Button(String(localized: .gotIt), role: .cancel) { }
                }, message: {
                    Text(accountVM.alertMessage)
                })
    }
}

#Preview {
    UpdateAccountEmail(email: nil)
}
