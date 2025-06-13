//
//  HivesService.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/05/2025.
//

import Foundation
import FirebaseFirestore

final class HivesService: HivesServiceProtocol {
    
    private let db: Firestore = Firestore.firestore()
    private let hivesCollection = "hives"
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // dependencies
    private let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
    }
    
    func fetchHives(for userId: String) async throws -> [Hive] {
        let snapshot = try await db.collection(hivesCollection)
            .whereField("user_id", isEqualTo: userId)
            //.order(by: "created_at", descending: false)
            .getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: Hive.self, decoder: decoder)
        }
    }
    
    func getHive(hiveId: String) async throws -> Hive {
        let document = try await db.collection(hivesCollection)
            .document(hiveId)
            .getDocument()
        
        return try document.data(as: Hive.self, decoder: decoder)
    }
    
    func addHive(_ hive: Hive, image: UIImage) async throws {
        let documentRef = db.collection(hivesCollection).document()
        
        var hiveWithId = hive
        
        hiveWithId = Hive(
            hiveId: documentRef.documentID,
            userId: hive.userId,
            name: hive.name,
            photoUrl: "", // initially empty
            estDate: hive.estDate,
            framesNumber: hive.framesNumber,
            healthState: hive.healthState,
            motherState: hive.motherState,
            lastFeedDate: hive.lastFeedDate,
            lastFeedAmount: hive.lastFeedAmount,
            address: hive.address,
            latitude: hive.latitude,
            longitude: hive.longitude
        )
        
        do {
            let photoUrl = try await storageService.uploadHiveImage(image, hiveId: documentRef.documentID) // Upload image
            hiveWithId.photoUrl = photoUrl // Set the URL
            try documentRef.setData(from: hiveWithId, encoder: encoder)
        } catch {
            throw error
        }
    }
    
    func editHive(_ hive: Hive) async throws {
        try db.collection(hivesCollection)
            .document(hive.hiveId)
            .setData(from: hive, encoder: encoder)
    }
    
    func deleteHive(hiveId: String) async throws {
        let hive = try await getHive(hiveId: hiveId)

        try await db.collection(hivesCollection).document(hiveId).delete()

        if !hive.photoUrl.isEmpty {
            try await storageService.deleteHiveImage(at: hive.photoUrl)
        }
    }
}

