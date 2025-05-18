//
//  ExpensesView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import SwiftUI

struct TransactionsView: View {
    
    @EnvironmentObject var viewModel: TransactionsViewModel
    @State private var isAddingNewTransaction: Bool = false
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    
                    totalIncomes
                    
                    totalExpenses
                    
                }
                .shadow(radius: 5)
                .cornerRadius(20)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        
                        Text("Current Balance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            
                        Text("\(viewModel.balance.asCurrencyString) $")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    Button {
                        isAddingNewTransaction = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add new transaction")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .background(.orange)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            
            Section {
                
                HStack {
                    Text("Recent Activity")
                        .font(.headline)
                }
                if !viewModel.transactionsArray.isEmpty {
                    ForEach(viewModel.transactionsArray.prefix(5), id: \.transactionId) { transaction in
                        TransactionRowCell(transactionModel: transaction)
                            .listRowSeparator(.hidden)
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
                } else {
                    noTransactions
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Finances")
        .sheet(isPresented: $isAddingNewTransaction) {
            AddTransactionView()
        }
        .onAppear {
            Task {
                await viewModel.loadTransactions()
            }
        }
        .refreshable {
            await viewModel.loadTransactions()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: AllTransactionsView()) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("See all")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
    
    var totalIncomes: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Total Incomes")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(viewModel.totalIncomes.asCurrencyString) $")
                .font(.headline)
                .fontWeight(.bold)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .padding(.horizontal, 2)
        .padding(.vertical, 8)
    }
    
    var totalExpenses: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Total Expenses")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(viewModel.totalExpenses.asCurrencyString) $")
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .padding(.horizontal, 2)
        .padding(.vertical, 8)
    }
    
    var noTransactions: some View {
        ContentUnavailableView(
            "No transactions yet",
            systemImage: "tray",
            description: Text("Add new transactions to see them here.")
        )
    }
}

#Preview {
    NavigationStack {
        TransactionsView()
            .environmentObject(TransactionsViewModel(
                authService: AuthenticationService(),
                transactionsService: TransactionsService()
            ))
    }
}
