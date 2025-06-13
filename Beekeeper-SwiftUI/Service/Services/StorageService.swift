//
//  FirebaseStorageService.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 13/06/2025.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageService: StorageServiceProtocol {
    
    private let storage = Storage.storage()
    private let hivesImagesPath = "hive_images"
    
    func uploadHiveImage(_ image: UIImage, hiveId: String) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw StorageError.invalidImageData
        }
        
        let fileName = "\(hiveId)_\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child(hivesImagesPath).child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        
        return downloadURL.absoluteString
    }
    
    func deleteHiveImage(at url: String) async throws {
        guard let imageURL = URL(string: url) else {
            throw StorageError.invalidURL
        }
        
        let storageRef = storage.reference(forURL: imageURL.absoluteString)
        try await storageRef.delete()
    }
}

enum StorageError: LocalizedError {
    case invalidImageData
    case invalidURL
    case uploadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidImageData:
            return "Failed to process image data"
        case .invalidURL:
            return "Invalid URL"
        case .uploadFailed:
            return "Failed to upload image"
        }
    }
}
