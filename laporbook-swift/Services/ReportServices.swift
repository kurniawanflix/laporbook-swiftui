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
    
    func createReport(title: String, location: String = "-", instance: String, desc: String, path: String, filename: String) async throws {
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
            "fullname": fsUser.fullname ?? ""
        ]
        try await Firestore.firestore().collection("report").document(autoID).setData(data, merge: true)
    }
    
    func loadAllReports() async throws -> [ReportModel] {
        var tempArray = [ReportModel]()
        let qs = try await Firestore.firestore().collection("report").getDocuments()
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
            tempArray.append(ReportModel(date: date, id: id, desc: desc, imgFilename: imgFile, imgPath: imgPath, instance: instance, title: title, userId: uid, fullname: fullname, status: status))
        }
        return tempArray
    }
    
    func changeStatus(to newStatus: String, id: String) async throws {
        try await Firestore.firestore().collection("report").document(id).setData(["status": newStatus], merge: true)
    }
}
