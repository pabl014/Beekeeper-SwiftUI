//
//  TransactionsService.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import Foundation
import FirebaseFirestore

protocol TransactionsServiceProtocol {
    func addTransaction(_ transaction: TransactionModel) async throws
    func deleteTransaction(id: String) async throws
    func getAllTransactions(userId: String) async throws -> [TransactionModel]
}

final class TransactionsService: TransactionsServiceProtocol {
    
    private let db = Firestore.firestore()
    private let transactionsCollection = "transactions"

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
    
    func addTransaction(_ transaction: TransactionModel) async throws {
        let docRef = db.collection(transactionsCollection).document()
        
        let transactionWithFirestoreId = TransactionModel(
            transactionId: docRef.documentID,
            userId: transaction.userId,
            name: transaction.name,
            amount: transaction.amount,
            type: transaction.type,
            date: transaction.date
        )
        
        try docRef.setData(from: transactionWithFirestoreId, encoder: encoder)
    }
    
    func deleteTransaction(id: String) async throws {
        try await db.collection(transactionsCollection).document(id).delete()
    }
    
    func getAllTransactions(userId: String) async throws -> [TransactionModel] {
        let snapshot = try await db.collection(transactionsCollection)
            .whereField("user_id", isEqualTo: userId)
            .getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: TransactionModel.self, decoder: decoder)
        }
    }
}
