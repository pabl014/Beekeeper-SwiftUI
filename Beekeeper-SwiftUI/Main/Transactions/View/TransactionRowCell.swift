//
//  TransactionRowCell.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import SwiftUI

struct TransactionRowCell: View {
    
    let transactionModel: TransactionModel
    
    private var formattedAmountWithSign: String {
        let sign = transactionModel.type == 0 ? "- " : ""
        return "\(sign)\(transactionModel.amount.asCurrencyString) $"
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(transactionModel.type == 1 ? Color.orange : Color.pink.opacity(0.8))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: transactionModel.type == 1 ? "arrow.up" : "arrow.down")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                )
            
            VStack(alignment: .leading) {
                Text(transactionModel.name)
                    .fontWeight(.medium)
                Text(transactionModel.date.asShortDate)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(formattedAmountWithSign)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(transactionModel.type == 1 ? Color.orange.opacity(0.3) : Color.pink.opacity(0.3))
        .cornerRadius(20)
    }
}

#Preview {
    List(TransactionModel.MOCK_TRANSACTIONS, id: \.transactionId) { transaction in
        TransactionRowCell(transactionModel: transaction)
    }
}
