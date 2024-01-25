//
//  AddCommentView.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 25/01/24.
//

import SwiftUI

struct AddCommentView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var viewModel = DetailReportViewModel()
    
    @State private var comment: String = ""
    
    var reportId: String
    
    @FocusState var descFocus: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 10)
                    VStack(alignment: .leading) {
                        Text("Komentar")
                            .font(.custom("Poppins-Bold", size: 14))
                        TextField("Komentar Anda", text: $viewModel.comment, axis: .vertical)
                            .font(.custom("Poppins-Regular", size: 14))
                            .frame(height: 100)
                            .padding()
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(descFocus ? Color(hex: LB.AppColors.primaryColor) : .gray, lineWidth: 2)
                                    .opacity(descFocus ? 1 : 0.5)
                            )
                            .focused($descFocus)
                    }
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.addComm(reportId: self.reportId)
                                presentation.wrappedValue.dismiss()
                            }
                        }
                    }, label: {
                        CustomButtonView(name: "Tambah Komentar")
                    })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Tambah Komentar")
                            .font(.custom("Poppins-Bold", size: 20))
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(hex: LB.AppColors.primaryColor), for: .navigationBar)
        }
    }
}

#Preview {
    AddCommentView(reportId: "")
}
