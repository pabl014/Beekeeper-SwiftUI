//
//  Transaction.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import Foundation

struct TransactionModel: Codable {
    let transactionId: String
    let userId: String
    let name: String
    let amount: Double
    let type: Int // 0 = expense, 1 = income
    let date: Date
}

extension TransactionModel {
    
    static let mock1 = TransactionModel(
        transactionId: UUID().uuidString,
        userId: UUID().uuidString,
        name: "Nowe ramki do ula #345",
        amount: 120.50,
        type: 0,
        date: Date()
    )
    
    static let mock2 = TransactionModel(
        transactionId: UUID().uuidString,
        userId: UUID().uuidString,
        name: "Słoik miodu dla Zbyszka",
        amount: 50.00,
        type: 1,
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
    )
    
    static let mock3 = TransactionModel(
        transactionId: UUID().uuidString,
        userId: UUID().uuidString,
        name: "Słoik miodu dla Tadzika",
        amount: 50.00,
        type: 1,
        date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
    )
    
    static let mock4 = TransactionModel(
        transactionId: UUID().uuidString,
        userId: UUID().uuidString,
        name: "Naprawa ula #456",
        amount: 150.00,
        type: 0,
        date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()
    )
    
    static let mock5 = TransactionModel(
        transactionId: UUID().uuidString,
        userId: UUID().uuidString,
        name: "Pokarm dla pszczół",
        amount: 75.59,
        type: 0,
        date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    )
    
    static let MOCK_TRANSACTIONS: [TransactionModel] = [
        mock1, mock2, mock3, mock4, mock5
    ]
}
