//
//  Model.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import Foundation
import FirebaseAuth

struct AuthUser {
    let uid: String
    let email: String?
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

struct FSUser {
    let uid: String
    let email: String?
    let fullname: String?
    let phone: String?
    let role: String?
    init(uid: String, email: String?, fullname: String?, phone: String?, role: String?) {
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.phone = phone
        self.role = role
    }
}

struct ReportModel: Hashable, Codable {
    let date: Date?
    let id: String?
    let desc: String?
    let imgFilename: String?
    let imgPath: String?
    let instance: String?
    let title: String?
    let userId: String?
    let fullname: String?
    let status: String?
    let latitude: Double?
    let longitude: Double?
}

struct LikeModel: Hashable, Codable {
    let date: Date?
    let author: String?
    let id: String?
}
