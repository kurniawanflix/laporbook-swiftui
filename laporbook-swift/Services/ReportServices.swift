//
//  ReportServices.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import Foundation
import FirebaseFirestore

final class ReportServices {
    static let instance = ReportServices()
    private init() { }
    
    func createReport(title: String, location: String = "-", instance: String, desc: String, path: String, filename: String, lat: Double, long: Double) async throws {
        let user = try AuthServices.instance.getAuthUser()
        let fsUser = try await AuthServices.instance.getFSUser(user: user)
        let autoID = Firestore.firestore().collection("report").document().documentID
        let data : [String: Any] = [
            "date": Timestamp(),
            "desc": desc,
            "id": autoID,
            "userId": user.uid,
            "reportTitle": title,
            "instance": instance,
            "imagePath": path,
            "imageFilename": filename,
            "status": "Posted",
            "fullname": fsUser.fullname ?? "",
            "latitude": lat,
            "longitude": long
        ]
        try await Firestore.firestore().collection("report").document(autoID).setData(data, merge: true)
    }
    
    func loadAllReports(byId: String = "") async throws -> [ReportModel] {
        var tempArray = [ReportModel]()
        let allQuery = try await Firestore.firestore().collection("report").getDocuments()
        let specificQuery = try await Firestore.firestore().collection("report").whereField("userId", isEqualTo: byId).getDocuments()
        let qs = byId == "" ? allQuery : specificQuery
        for report in qs.documents {
            let timestamp = report["date"] as? Timestamp
            let date = timestamp?.dateValue() as? Date
            let desc = report["desc"] as? String
            let id = report["id"] as? String ?? ""
            let imgFile = report["imageFilename"] as? String
            let imgPath = report["imagePath"] as? String
            let instance = report["instance"] as? String
            let title = report["reportTitle"] as? String
            let uid = report["userId"] as? String
            let fullname = report["fullname"] as? String
            let status = report["status"] as? String
            let lat = report["latitude"] as? Double
            let long = report["longitude"] as? Double
            tempArray.append(ReportModel(date: date, id: id, desc: desc, imgFilename: imgFile, imgPath: imgPath, instance: instance, title: title, userId: uid, fullname: fullname, status: status, latitude: lat, longitude: long))
        }
        return tempArray
    }
    
    func changeStatus(to newStatus: String, id: String) async throws {
        try await Firestore.firestore().collection("report").document(id).setData(["status": newStatus], merge: true)
    }
    
    func loadAllLikes(reportId: String) async throws -> [LikeModel] {
        var tempArray = [LikeModel]()
        let qs = try await Firestore.firestore().collection("report").document(reportId).collection("likes").getDocuments()
        for like in qs.documents {
            let timestamp = like["date"] as? Timestamp
            let date = timestamp?.dateValue() as? Date
            let id = like["id"] as? String
            let author = like["author"] as? String
            tempArray.append(LikeModel(date: date, author: author, id: id))
        }
        return tempArray
    }
    
    func checkLike(array: [LikeModel], query: String) -> Bool {
        return array.contains {
            $0.author == query
        }
    }
    
    func filterModel(by author: String, in models: [LikeModel]) -> LikeModel? {
        return models.first { $0.author == author }
    }
    
    func addLike(reportId: String, author: String) async throws -> String {
        let autoID = Firestore.firestore().collection("report").document(reportId).collection("likes").document().documentID
        let data: [String: Any] = [
            "date": Timestamp(),
            "author": author,
            "id": autoID
        ]
        
        try await Firestore.firestore().collection("report").document(reportId).collection("likes").document(autoID).setData(data)
        
        return autoID
    }
    
    func delLike(reportId: String, likeId: String) async throws {
        try await Firestore.firestore().collection("report").document(reportId).collection("likes").document(likeId).delete()
    }
}
