//
//  DetailReportView.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

@MainActor
final class DetailReportViewModel: ObservableObject {
    @Published var user: FSUser = FSUser(uid: "", email: "", fullname: "", phone: "", role: "")
    @Published var isLiked: Bool = false
    
    @Published var allLikes: [LikeModel] = []
    @Published var like: LikeModel? = LikeModel(date: Date(), author: "", id: "")
    
    func changeStatus(to newStatus: String, reportId: String) async throws {
        do {
            try await ReportServices.instance.changeStatus(to: newStatus, id: reportId)
        } catch {
            print("Error change status:", error.localizedDescription)
        }
    }
    func addLike(reportId: String) async throws {
        let auth = try AuthServices.instance.getAuthUser()
        let result = try await AuthServices.instance.getFSUser(user: auth)
        try await ReportServices.instance.addLike(reportId: reportId, author: result.fullname ?? "")
    }
    
    func delLike(reportId: String, likeId: String) async throws {
        try await ReportServices.instance.delLike(reportId: reportId, likeId: likeId)
    }
}

struct DetailReportView: View {
    @Environment(\.presentationMode) var presentation
    @State private var changeStatusDialog: Bool = false
    @StateObject private var viewModel = DetailReportViewModel()
    
    var data: ReportModel?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 10) {
                    Text(data?.title ?? "")
                        .font(.custom("Poppins-Bold", size: 30))
                        .padding(.top, 20)
                    WebImage(url: URL(string: data?.imgPath ?? ""))
                        .resizable()
                        .placeholder(content: {
                            ProgressView()
                                .font(.title)
                                .frame(height: UIScreen.main.bounds.height * 0.3)
                                .frame(maxWidth: .infinity)
                        })
                        .onFailure(perform: { _ in
                            VStack(spacing: 16) {
                                Image(systemName: "wifi.slash")
                                    .font(.largeTitle)
                                Text("Gagal mengunduh")
                            }
                        })
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height * 0.2)
                        .frame(maxWidth: .infinity)
                        .frame(alignment: .center)
                        .padding(.top, 20)
                    HStack{
                        VStack{
                            Text(data?.status ?? "")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(width: 150, height: 30)
                        .background(getBackgroundColor(for: data?.status))
                        .cornerRadius(10)
                        VStack{
                            Text(data?.instance ?? "")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    
                    HStack{
                        Button(action: {
                            if viewModel.isLiked {
                                Task {
                                    do {
                                        try await viewModel.delLike(reportId: data?.id ?? "", likeId: viewModel.like?.id ?? "")
                                        viewModel.allLikes = try await ReportServices.instance.loadAllLikes(reportId: data?.id ?? "")
                                        viewModel.like = ReportServices.instance.filterModel(by: data?.fullname ?? "", in: viewModel.allLikes)
                                        viewModel.isLiked = false
                                    }
                                }
                            } else {
                                Task {
                                    do {
                                        try await viewModel.addLike(reportId: data?.id ?? "")
                                        viewModel.allLikes = try await ReportServices.instance.loadAllLikes(reportId: data?.id ?? "")
                                        viewModel.like = ReportServices.instance.filterModel(by: data?.fullname ?? "", in: viewModel.allLikes)
                                        viewModel.isLiked = true
                                    }
                                }
                            }
                        }, label: {
                            Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")                                .foregroundStyle(.white)
                                .padding()
                        })
                        .frame(width: 150, height: 30)
                        .background(.accent)
                        .cornerRadius(10)
                        VStack{
                            Text("\(viewModel.allLikes.count) Like")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .cornerRadius(10)
                    }
                    
                    HStack{
                        Image(systemName: "person.fill")
                        VStack{
                            Text("Nama Pelapor")
                                .font(.custom("Poppins-Bold", size: 14))
                            Text(data?.fullname ?? "")
                                .font(.custom("Poppins-Regular", size: 12))
                        }
                    }
                    .padding(.top, 20)
                    HStack{
                        HStack{
                            Image(systemName: "calendar")
                            VStack{
                                Text("Tanggal Laporan")
                                    .font(.custom("Poppins-Bold", size: 14))
                                Text(String(date: data?.date ?? Date(), format: "dd MMMM yyy"))
                                    .font(.custom("Poppins-Regular", size: 12))
                            }
                        }
                        VStack{
                            Image(systemName: "map")
                            VStack{
                                Button("Lokasi") {
                                    UIApplication.shared.open(URL(string: "comgooglemaps://?q=\(data?.latitude ?? 0),\(data?.longitude ?? 0)")!)
                                }
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundStyle(.black)
                            }
                        }
                    }
                    
                    Text("Deskripsi Lengkap")
                        .font(.custom("Poppins-Bold", size: 20))
                        .padding(.top, 20)
                    
                    Text(data?.desc ?? "")
                        .font(.custom("Poppins-Regular", size: 12))
                    
                    Button(action: {
                        if viewModel.user.role == "admin" {
                            changeStatusDialog.toggle()
                        }
                    }, label: {
                        CustomButtonChangeView(name: "Ubah Status")
                    })
                }
                .padding()
            })
        }
        .confirmationDialog("", isPresented: $changeStatusDialog) {
            Button("Posted") {
                Task {
                    do {
                        try await viewModel.changeStatus(to: "Posted", reportId: data?.id ?? "")
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            Button("Proses") {
                Task {
                    do {
                        try await viewModel.changeStatus(to: "Proses", reportId: data?.id ?? "")
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            Button("Done") {
                Task {
                    do {
                        try await viewModel.changeStatus(to: "Done", reportId: data?.id ?? "")
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        } message: {
            Text("Ubah status laporan")
        }
        
        .onAppear(perform: {
            Task {
                do {
                    let auth = try AuthServices.instance.getAuthUser()
                    viewModel.user = try await AuthServices.instance.getFSUser(user: auth)
                    viewModel.allLikes = try await ReportServices.instance.loadAllLikes(reportId: data?.id ?? "")
                    viewModel.isLiked = ReportServices.instance.checkLike(array: viewModel.allLikes, query: viewModel.user.fullname ?? "")
                    viewModel.like = ReportServices.instance.filterModel(by: viewModel.user.fullname ?? "", in: viewModel.allLikes)
                } catch {
                    print("Error getting user role:", error.localizedDescription)
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Detail Laporan")
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
    func getBackgroundColor(for status: String?) -> Color {
        switch status {
        case "Posted":
            return Color(hex: LB.AppColors.dangerColor)
        case "Proses":
            return Color(hex: LB.AppColors.warningColor)
        case "Done":
            return Color(hex: LB.AppColors.successColor)
        default:
            return Color.gray
        }
    }
}

#Preview {
    NavigationStack {
        DetailReportView(data: ReportModel(date: Date(), id: "12345", desc: "Deskripsi", imgFilename: "", imgPath: "", instance: "Suatu Instansi", title: "", userId: "", fullname: "Nama Pelapor", status: "Done", latitude: 0, longitude: 0))
    }
}
