//
//  StorageServices.swift
//  laporbook-swift
//
//  Created by Muhammad David Kurniawan on 05/01/24.
//

import Foundation
import FirebaseStorage

final class StorageServices {
    static let instance = StorageServices()
    private init() { }
    private let storage = Storage.storage().reference()
    private var imageReference: StorageReference {
        storage.child("imageReport")
    }
    
    func saveImage(data: Data) async throws -> (path: String, filename: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString.lowercased()).jpeg"
        let returnedMetadata = try await imageReference.child(path).putDataAsync(data, metadata: meta)
        
        guard let _ = returnedMetadata.path, let returnedName = returnedMetadata.name else {
            throw URLError(.badServerResponse)
        }
        let imageUrl = try await imageReference.child(path).downloadURL()
        return (imageUrl.absoluteString, returnedName)
    }
}
