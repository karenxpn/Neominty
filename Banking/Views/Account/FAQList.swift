//
//  FAQList.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import SwiftUI

struct FAQList: View {
    @EnvironmentObject var accountVM: AccountViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            LazyVStack {
                
                ForEach(accountVM.faqs, id: \.id) { faq in
                    VStack(alignment: .leading, spacing: 8) {
                        TextHelper(text: faq.question, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                        TextHelper(text: faq.answer, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)

                    }.padding(20)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(AppColors.border, lineWidth: 1)
                        }
                }
                
                if accountVM.loading {
                    ProgressView()
                }
                
                ButtonHelper(disabled: accountVM.loading, label: NSLocalizedString("loadMore", comment: ""), color: AppColors.superLightGray, labelColor: AppColors.darkBlue) {
                    
                    accountVM.getFaqs()
                }.padding(.top, 35)
            }.padding(.bottom, UIScreen.main.bounds.height * 0.15)
        }.scrollDismissesKeyboard(.immediately)
    }
}

struct FAQList_Previews: PreviewProvider {
    static var previews: some View {
        FAQList()
    }
}
