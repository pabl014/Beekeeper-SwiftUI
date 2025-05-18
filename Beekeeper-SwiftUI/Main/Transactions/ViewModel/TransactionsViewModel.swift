//
//  TransactionsViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import Foundation

@MainActor
final class TransactionsViewModel: ObservableObject {
    
    @Published var transactionsArray: [TransactionModel] = []
    @Published var isLoading: Bool = false
    
    private var currentUserId: String? {
        authService.currentUserId
    }
    
    var totalExpenses: Double {
        transactionsArray
            .filter { $0.type == 0 }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var totalIncomes: Double {
        transactionsArray
            .filter { $0.type == 1 }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var balance: Double {
        totalIncomes - totalExpenses
    }
    
    // Dependencies:
    private let transactionsService: TransactionsServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthenticationService(), transactionsService: TransactionsServiceProtocol = TransactionsService()) {
        self.authService = authService
        self.transactionsService = transactionsService
    }
    
    func loadTransactions() async {
        guard let userId = currentUserId else {
            return
        }
        
        isLoading = true
        
        do {
            transactionsArray = try await transactionsService.getAllTransactions(userId: userId)
        } catch {
            print("Failed to load transactions: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func addTransaction(name: String, amount: Double, type: Int, date: Date) async {
        guard let userId = currentUserId else {
            print("No user logged in")
            return
        }
        
        isLoading = true
        
        do {
            let newTransaction = TransactionModel(
                transactionId: "temp_id",
                userId: userId,
                name: name,
                amount: amount,
                type: type,
                date: date
            )
            
            try await transactionsService.addTransaction(newTransaction)
            await loadTransactions()
        } catch {
            print("Failed to add transaction: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func deleteTransaction(id: String) async {
        isLoading = true
        
        do {
            try await transactionsService.deleteTransaction(id: id)
            
            if let index = transactionsArray.firstIndex(where: { $0.transactionId == id }) {
                transactionsArray.remove(at: index)
            } else {
                await loadTransactions()
            }
        } catch {
            print("Failed to delete transaction: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
