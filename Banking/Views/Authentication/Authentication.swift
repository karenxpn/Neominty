//
//  Authentication.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import SwiftUI

struct Authentication: View {
    @StateObject var authVM = AuthViewModel()
    @State private var showPicker: Bool = false
    @State private var animate: Bool = false
    
    var body: some View {
        Loading(isShowing: $authVM.loading) {
            VStack( alignment: .leading, spacing: 19) {
                
                Spacer()
                
                
                VStack( alignment: .leading, spacing: 8) {
                    TextHelper(text: NSLocalizedString("hiThere", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    TextHelper(text: NSLocalizedString("welcomeBack", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 16)
                    
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
                            .background(AppColors.superLightGray)
                            .cornerRadius(16, corners: [.topLeft, .bottomLeft])
                    }
                    
                    TextField("(555) 555-1234", text: $authVM.phoneNumber)
                        .keyboardType(.phonePad)
                        .font(.custom(Roboto.regular.rawValue, size: 16))
                        .padding(.leading, 5)
                        .frame(height: 56)
                        .background(AppColors.superLightGray)
                        .cornerRadius(16, corners: [.topRight, .bottomRight])
                }
                
                Spacer()
                
                
                ButtonHelper(disabled: authVM.phoneNumber == "" || authVM.loading,
                             label: NSLocalizedString("next", comment: "")) {
                    authVM.sendVerificationCode()
                }.padding(.horizontal, 7)
                    .navigationDestination(isPresented: $authVM.navigate, destination: {
                        VerifyPhoneNumber(phone: "\(authVM.code)\(authVM.phoneNumber)")
                            .environmentObject(authVM)
                    })
                
            }
        }.navigationBarHidden(true)
            .navigationBarTitle("")
        
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding([.horizontal, .top], 30)
            .padding(.bottom, UIScreen.main.bounds.height * 0.08)
            .sheet(isPresented: $showPicker) {
                CountryCodeSelection(isPresented: $showPicker, country: $authVM.country, code: $authVM.code, flag: $authVM.flag)
            }
            .alert(isPresented: $authVM.showAlert) {
                Alert(title: Text(NSLocalizedString("error", comment: "")),
                      message: Text(authVM.alertMessage),
                      dismissButton: .default(Text(NSLocalizedString("gotIt", comment: ""))))
            }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
