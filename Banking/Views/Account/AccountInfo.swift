//
//  AccountInfo.swift
//  Banking
//
//  Created by Karen Mirakyan on 03.04.23.
//

import SwiftUI

struct AccountInfo: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var accountVM = AccountViewModel()
    @State private var name: String
    @State private var flag: String
    @State private var phone: String
    @State private var email: String
    @State private var emailValid: Bool
    
    init(name: String?, flag: String?, phone: String?, email: String?) {
        _name = State(initialValue: name ?? "")
        _flag = State(initialValue: flag ?? "")
        _phone = State(initialValue: phone ?? "")
        _email = State(initialValue: email ?? "")
        _emailValid = State(initialValue: email?.isEmail ?? false)
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TextHelper(text: NSLocalizedString("yourName", comment: ""), color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 16)
                        
                        TextField(NSLocalizedString("John Smith", comment: ""), text: $name)
                            .font(.custom(Roboto.medium.rawValue, size: 16))
                            .padding(.leading, 16)
                            .frame(height: 56)
                            .background(AppColors.superLightGray)
                            .cornerRadius(16)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        TextHelper(text: NSLocalizedString("phoneNumber", comment: ""), color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 16)

                        HStack(spacing: 0) {
                            
                            Button {
                                
                            } label: {
                                HStack {
                                    TextHelper(text: "\(flag)",
                                               fontName: Roboto.bold.rawValue, fontSize: 18)
                                    
                                    Image("drop_arrow")
                                    
                                }.frame(height: 56)
                                    .padding(.horizontal, 10)
                                    .background(AppColors.superLightGray)
                                    .cornerRadius(16, corners: [.topLeft, .bottomLeft])
                            }.disabled(true)
                            
                            TextField(NSLocalizedString("enterSenderPhone", comment: ""), text: $phone)
                                .keyboardType(.phonePad)
                                .font(.custom(Roboto.regular.rawValue, size: 16))
                                .padding(.leading, 5)
                                .frame(height: 56)
                                .background(AppColors.superLightGray)
                                .cornerRadius(16, corners: [.topRight, .bottomRight])
                                .disabled(true)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TextHelper(text: NSLocalizedString("email", comment: ""), color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 16)
                        
                        CardDetailTextFieldDecorator(content: {
                            TextField(NSLocalizedString("example@domain.com", comment: ""), text: $email)
                                .font(.custom(Roboto.medium.rawValue, size: 16))
                                .padding(.leading, 16)
                        }, isValid: $emailValid)
                        
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Image("info")
                        TextHelper(text: NSLocalizedString("emailInfo", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 11)
                        
                    }.padding(.top, 38)
                    
                    
                    Spacer()
                    
                    ButtonHelper(disabled: (!emailValid && !email.isEmpty) || name.isEmpty || accountVM.loading, label: accountVM.loading ? NSLocalizedString("pleaseWait", comment: "") : NSLocalizedString("save", comment: "")) {
                        accountVM.updateInfo(name: name, email: email)
                    }.padding(.bottom, UIScreen.main.bounds.height * 0.15)
                    
                }
                .frame(minHeight: geometry.size.height)
                .padding(24)
            }.frame(width: geometry.size.width)
                .padding(.top, 1)
                .scrollDismissesKeyboard(.immediately)
        }.navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("accountInfo", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }.onReceive(NotificationCenter.default.publisher(for:
                                                                Notification.Name(rawValue: NotificationName.infoUpdated.rawValue))) { _ in
                viewRouter.popToAccountRoot()
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $accountVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(accountVM.alertMessage)
            })
    }
}

struct AccountInfo_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfo(name: "Karen Mirakyan", flag: "🇦🇲", phone: "93936313", email: nil)
            .environmentObject(ViewRouter())
    }
}
