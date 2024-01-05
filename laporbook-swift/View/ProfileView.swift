//
//  ProfileView.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import SwiftUI

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var role: String = ""
    
    func checkUser() async throws {
        let auth = try AuthServices.instance.getAuthUser()
        let result = try await AuthServices.instance.getFSUser(user: auth)
        
        self.email = result.email ?? ""
        self.fullName = result.fullname ?? ""
        self.phone = result.phone ?? ""
        self.role = result.role ?? ""
    }
}

struct ProfileView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    Spacer()
                        .frame(minHeight: 80)
                    Image(systemName: "person.circle")
                        .font(.system(size: 150))
                        .foregroundStyle(Color(hex: LB.AppColors.primaryColor))
                        .padding(.bottom, 20)
                    Text(viewModel.fullName)
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundStyle(Color(hex: LB.AppColors.primaryColor))
                    Text("admin")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundStyle(Color(hex: LB.AppColors.primaryColor))
                    VStack(alignment: .leading){
                        Text(viewModel.phone)
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundStyle(Color(hex: LB.AppColors.primaryColor))
                        Divider()
                            .frame(height: 3)
                            .overlay((Color(hex: LB.AppColors.primaryColor)))
                        Text(viewModel.email)
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundStyle(Color(hex: LB.AppColors.primaryColor))
                        Divider()
                            .frame(height: 3)
                            .overlay((Color(hex: LB.AppColors.primaryColor)))
                    }
                    .padding(.top, 20)
                    Button(action: {
                        Task {
                            do {
                                try AuthServices.instance.logoutUser()
                                withAnimation {
                                    self.router.currentPage = .login
                                }
                            }
                        }
                    }, label: {
                        CustomButtonView(name: "Logout")
                    })
                }
                .padding()
                .onAppear(){
                    Task {
                        do {
                            try await viewModel.checkUser()
                        }
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Lapor Book")
                            .font(.custom("Poppins-Bold", size: 20))
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
    NavigationStack {
        ProfileView()
    }
}
