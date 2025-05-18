//
//  AddTransactionView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 18/05/2025.
//

import SwiftUI

struct AddTransactionView: View {
    
    @EnvironmentObject var viewModel: TransactionsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var transactionName = ""
    @State private var amount = ""
    @State private var transactionType = 0
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Transaction Name", text: $transactionName)
                        .autocorrectionDisabled()
                    
                    HStack {
                        Text("$")
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("Type", selection: $transactionType) {
                        Text("Expense").tag(0)
                        Text("Income").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button {
                        addTransaction()
                        dismiss()
                    } label: {
                        Text("Add Transaction")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .background(transactionName.isEmpty || amount.isEmpty ? Color.orange.opacity(0.5) : Color.orange)
                            .cornerRadius(10)
                    }
                    .disabled(transactionName.isEmpty || amount.isEmpty)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .disabled(viewModel.isLoading)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
    
    private func addTransaction() {
        
        guard let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) else {
            return
        }
        
        Task {
            await viewModel.addTransaction(
                name: transactionName,
                amount: amountValue,
                type: transactionType,
                date: date
            )
        }
    }
}

#Preview {
    AddTransactionView()
        .environmentObject(TransactionsViewModel(
            authService: AuthenticationService(),
            transactionsService: TransactionsService()
        ))
}
