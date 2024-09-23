//
//  CountryCodeSelection.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI

struct CountryCodeSelection: View {
    
    @Binding var isPresented: Bool
    @Binding var country: String
    @Binding var code: String
    @Binding var flag: String
    
    
    var body: some View {
        
        List {
            ForEach( Array( Credentials.countryCodeList.keys ).sorted(), id: \.self )  { key in
                
                Button {
                    code = Credentials.countryCodeList[key]!
                    country = key
                    flag = countryFlag(countryCode: key)
                    isPresented.toggle()
                } label: {
                    HStack( spacing: 14) {
                        TextHelper(text: countryFlag(countryCode: key), fontSize: 25)
                        TextHelper(text: key, colorResource: .appGray, fontName: Roboto.medium.rawValue, fontSize: 16)
                        TextHelper(text: countryName(countryCode: key) ?? "Unknown", colorResource: .darkBlue, fontName: Roboto.medium.rawValue, fontSize: 16)
                        
                        Spacer()
                        
                        if country == key {
                            Image("done")
                        }
                    }.padding( .vertical, 8)
                }.listRowSeparator(.hidden)
            }
        }.padding(.top, 1)

    }
    
    func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
}

struct CountryCodeSelection_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodeSelection(isPresented: .constant( false ), country: .constant( "AM" ), code: .constant(""), flag: .constant("🇦🇲"))
    }
}
