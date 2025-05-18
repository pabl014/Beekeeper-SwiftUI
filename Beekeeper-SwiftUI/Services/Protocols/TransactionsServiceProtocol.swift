//
//  TransactionsServiceProtocol.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 18/05/2025.
//

import Foundation

protocol TransactionsServiceProtocol {
    func addTransaction(_ transaction: TransactionModel) async throws
    func deleteTransaction(id: String) async throws
    func getAllTransactions(userId: String) async throws -> [TransactionModel]
}

