//
//  MyReportView.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import SwiftUI

@MainActor
final class MyReportViewModel: ObservableObject {
    @Published var data: [ReportModel] = []
    @Published var userId: String = ""
    
    func loadReports() async throws {
        self.data = try await ReportServices.instance.loadAllReports()
    }
}

struct MyReportView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = MyReportViewModel()
    
    let columnSize: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    var body: some View {
        return AnyView(
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: columnSize) {
                        ForEach(viewModel.data, id: \.self) { each in
                            NavigationLink(destination: DetailReportView(data: each)) {
                                CardReportView(data: each)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
                .navigationBarItems(
                    trailing: NavigationLink(
                        destination: AddReportView(),
                        label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                    )
                )
                .onAppear(perform: {
                    Task {
                        do {
                            viewModel.userId = try AuthServices.instance.getAuthUser().uid
                            try await viewModel.loadReports()
                        } catch {
                            print("Error fetching all data when view appear:", error.localizedDescription)
                        }
                    }
                })
                .padding(.top, 20)
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
        )
    }
}

#Preview {
    MyReportView()
}
