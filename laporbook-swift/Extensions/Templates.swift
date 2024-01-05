//
//  Templates.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import SwiftUI

struct CustomTextFieldView: View {
    @Binding var fieldBinding: String
    @FocusState var focus: Bool
    @State var fieldName: String
    @State var isPassword: Bool = false
    @State private var isPasswordShown: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fieldName)
                .font(.custom("Poppins-Bold", size: 14))
            if !isPassword {
                if fieldName == "Email" {
                    TextField(fieldName, text: $fieldBinding)
                        .padding()
                        .font(.custom("Poppins-Regular", size: 14))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .frame(height: 45)
                        .keyboardType(.emailAddress)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(focus ? Color(hex: LB.AppColors.primaryColor) : .gray, lineWidth: 2)
                                .opacity(focus ? 1 : 0.5)
                        )
                        .focused($focus)
                } else {
                    TextField(fieldName, text: $fieldBinding)
                        .padding()
                        .font(.custom("Poppins-Regular", size: 14))
                        .autocorrectionDisabled()
                        .frame(height: 45)
                        .keyboardType(keyboardType)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(focus ? Color(hex: LB.AppColors.primaryColor) : .gray, lineWidth: 2)
                                .opacity(focus ? 1 : 0.5)
                        )
                        .textInputAutocapitalization(.words)
                        .focused($focus)
                }
            } else {
                HStack {
                    if isPasswordShown {
                        TextField(fieldName, text: $fieldBinding)
                            .font(.custom("Poppins-Regular", size: 14))
                            .focused($focus)
                    } else {
                        SecureField(fieldName, text: $fieldBinding)
                            .font(.custom("Poppins-Regular", size: 14))
                            .focused($focus)
                    }
                    Spacer()
                    Button(action: {
                        isPasswordShown.toggle()
                    }, label: {
                        Image(systemName: !isPasswordShown ? "eye.fill" : "eye.slash.fill")
                            .foregroundStyle(.gray)
                    })
                }
                .padding()
                .frame(height: 45)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(focus ? Color(hex: LB.AppColors.primaryColor) : .gray, lineWidth: 2)
                        .opacity(focus ? 1 : 0.5)
                )
            }
        }
        .padding(.bottom, 5)
    }
}

struct CustomButtonView: View {
    var name: String
    var isDisabled: Bool = false
    
    var body: some View {
        Text(name)
            .padding()
            .font(.custom("Poppins-Bold", size: 20))
            .frame(maxWidth: .infinity)
            .background(isDisabled ? (Color(hex: LB.AppColors.primaryColor)).opacity(0.5) :  (Color(hex: LB.AppColors.primaryColor)))
            .foregroundStyle(.white)
            .fontWeight(.black)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 50)))
            .padding(.top, 30)
    }
}

struct CustomButtonChangeView: View {
    var name: String
    var isDisabled: Bool = false
    
    var body: some View {
        Text(name)
            .padding()
            .font(.custom("Poppins-Bold", size: 16))
            .frame(width: 200)
            .background(isDisabled ? (Color(hex: LB.AppColors.primaryColor)).opacity(0.5) :  (Color(hex: LB.AppColors.primaryColor)))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .padding(.top, 30)
    }
}

#Preview {
    CustomButtonView(name: "Daftar", isDisabled: true)
        .previewLayout(.fixed(width: .infinity, height: 60))
        .previewDisplayName("Button")
}

#Preview {
    CustomTextFieldView(fieldBinding: .constant(""), fieldName: "Nama", isPassword: false)
}
