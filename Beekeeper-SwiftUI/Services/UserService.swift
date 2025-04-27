//
//  UserService.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/04/2025.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func createNewUser(user: DBUser) async throws
    func getUser(userId: String) async throws -> DBUser
    func incrementYardsCount(userId: String) async throws
}


final class UserService: UserServiceProtocol {
    
    private let db = Firestore.firestore()
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
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
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    func incrementYardsCount(userId: String) async throws {
        
        let data: [String: Any ] = [
            "yards_count" : FieldValue.increment(Int64(1))
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
}
