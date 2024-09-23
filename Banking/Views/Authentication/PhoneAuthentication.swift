//
//  PhoneAuthentication.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

struct PhoneAuthentication: View {
    @StateObject var authVM = AuthViewModel()
    @State private var showPicker: Bool = false
    @State private var animate: Bool = false
    
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            VStack( alignment: .leading, spacing: 19) {
                
                Spacer()
                
                
                VStack( alignment: .leading, spacing: 8) {
                    TextHelper(text: NSLocalizedString("hiThere", comment: ""), color: Color(.darkBlue), fontName: Roboto.bold.rawValue, fontSize: 24)
                    TextHelper(text: NSLocalizedString("welcomeBack", comment: ""), color: Color(.appGray), fontName: Roboto.regular.rawValue, fontSize: 16)
                }
                
                HStack(spacing: 0) {
                    
                    Button {
                        showPicker.toggle()
                    } label: {
                        HStack {
                            TextHelper(text: "\(authVM.flag)",
                                       fontName: Roboto.bold.rawValue, fontSize: 18)
                            
                            Image("drop_arrow")
                            
                        }.frame(height: 56)
                            .padding(.horizontal, 10)
                            .background(Color(.superLightGray))
                            .cornerRadius(16, corners: [.topLeft, .bottomLeft])
                    }
                    
                    TextField("(555) 555-1234", text: $authVM.phoneNumber)
                        .keyboardType(.phonePad)
                        .font(.custom(Roboto.regular.rawValue, size: 16))
                        .padding(.leading, 5)
                        .frame(height: 56)
                        .background(Color(.superLightGray))
                        .cornerRadius(16, corners: [.topRight, .bottomRight])
                }
                
                Spacer()
                
                
                ButtonHelper(disabled: authVM.phoneNumber == "" || authVM.loading,
                             label: NSLocalizedString("next", comment: "")) {
                    authVM.sendVerificationCode()
                }.padding(.horizontal, 7)
                    .navigationDestination(isPresented: $authVM.navigate, destination: {
                        VerifyPhoneNumber(phone: "+\(authVM.code)\(authVM.phoneNumber)")
                            .environmentObject(authVM)
                    })
                
            }.padding(24)
        }.navigationBarHidden(true)
            .navigationBarTitle("")
        
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .sheet(isPresented: $showPicker) {
                CountryCodeSelection(isPresented: $showPicker, country: $authVM.country, code: $authVM.code, flag: $authVM.flag)
            }.alert(NSLocalizedString("error", comment: ""), isPresented: $authVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(authVM.alertMessage)
            })
    }
}

struct PhoneAuthentication_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthentication()
    }
}
