//
//  CardReportView.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardReportView: View {
    @Environment(\.colorScheme) var colorScheme
    var data: ReportModel?
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 0) {
                WebImage(url: URL(string: data?.imgPath ?? ""))
                    .resizable()
                    .placeholder(content: {
                        ProgressView()
                            .font(.title)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height * 0.1)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    })
                    .onFailure(perform: { _ in
                        VStack(spacing: 16) {
                            Image(systemName: "wifi.slash")
                                .font(.largeTitle)
                            Text("Gagal mengunduh")
                        }
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.width * 0.3)
                    .clipped()
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(data?.title ?? "Title")")
                        .padding()
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .lineLimit(2)
                        .font(.headline)
                    Divider()
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                        .overlay(.black)
                    HStack(spacing: 0){
                        VStack{
                            Text(data?.status ?? "")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .background(getBackgroundColor(for: data?.status))
                        Divider()
                            .frame(width: 2)
                            .overlay(.black)
                        VStack{
                            Text("\(formatDate(data?.date ?? Date()))")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                    }
                }
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2)
        )
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getBackgroundColor(for status: String?) -> Color {
        switch status {
        case "Posted":
            return Color(hex: LB.AppColors.dangerColor)
        case "Process":
            return Color(hex: LB.AppColors.warningColor)
        case "Done":
            return Color(hex: LB.AppColors.successColor)
        default:
            return Color.gray
        }
    }
}

#Preview {
    CardReportView()
        .frame(height: 300)
}
