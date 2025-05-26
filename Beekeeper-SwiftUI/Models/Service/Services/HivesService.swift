//
//  HivesService.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/05/2025.
//

import Foundation
import FirebaseFirestore

protocol HivesServiceProtocol {
    func fetchHives(for userId: String) async throws -> [Hive]
    func getHive(hiveId: String) async throws -> Hive
}

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
}

