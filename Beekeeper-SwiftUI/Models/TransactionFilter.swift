//
//  TransactionFilter.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 18/05/2025.
//

import Foundation

enum TransactionFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case expenses = "Expenses"
    case incomes = "Incomes"
    
    var id: String { self.rawValue }
}
