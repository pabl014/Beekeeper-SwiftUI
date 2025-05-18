//
//  AllTransactionsView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 18/05/2025.
//

import SwiftUI

struct AllTransactionsView: View {
    
    @EnvironmentObject var viewModel: TransactionsViewModel
    @State private var selectedFilter: TransactionFilter = .all
    @State private var searchText = ""
    
    var filteredTransactions: [TransactionModel] {
        var filtered = viewModel.transactionsArray
        
        switch selectedFilter {
        case .expenses:
            filtered = filtered.filter { $0.type == 0 }
        case .incomes:
            filtered = filtered.filter { $0.type == 1 }
        case .all:
            break
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        return filtered.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        VStack {
            Picker("Filter", selection: $selectedFilter) {
                ForEach(TransactionFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            List {
                ForEach(filteredTransactions, id: \.transactionId) { transaction in
                    TransactionRowCell(transactionModel: transaction)
                        .contextMenu {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteTransaction(id: transaction.transactionId)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
            .overlay {
                if filteredTransactions.isEmpty {
                    noTransactions
                }
            }
        }
        .navigationTitle("All Transactions")
        .searchable(text: $searchText, prompt: "Search transactions...")
        .refreshable {
            await viewModel.loadTransactions()
        }
    }
    
    var noTransactions: some View {
        ContentUnavailableView(
            "No transactions",
            systemImage: "tray",
            description: Text(searchText.isEmpty ? "No transactions found for the selected filter" : "No transactions matching '\(searchText)'")
        )
    }
}

#Preview {
    NavigationStack {
        AllTransactionsView()
            .environmentObject(TransactionsViewModel(
                authService: AuthenticationService(),
                transactionsService: TransactionsService()
            ))
    }
}
