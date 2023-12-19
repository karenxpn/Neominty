//
//  AllFAQs.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import SwiftUI

struct AllFAQs: View {
    @StateObject private var faqVM = FAQViewModel()
    @State private var showDetail: Bool = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            
            LazyVStack {
                ForEach(faqVM.faqs, id: \.id) { faq in
                    Button {
                        showDetail.toggle()
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            TextHelper(text: faq.question, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            TextHelper(text: faq.answer, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)

                        }.padding(20)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(AppColors.border, lineWidth: 1)
                            }.onAppear {
                                if faq.id == faqVM.faqs.last?.id && !faqVM.loading {
                                    faqVM.getFAQs()
                                }
                            }
                    }.sheet(isPresented: $showDetail) {
                        FAQDetail(faq: faq)
                    }
                }
                
                if faqVM.loading {
                    ProgressView()
                }
            }.padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
        }.padding(.top, 1)
            .alert(NSLocalizedString("error", comment: ""), isPresented: $faqVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(faqVM.alertMessage)
            })
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("faq", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }
    }
}

struct AllFAQs_Previews: PreviewProvider {
    static var previews: some View {
        AllFAQs()
    }
}
