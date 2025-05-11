//
//  TestExpenseView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 10/05/2025.
//

import SwiftUI

struct TestExpenseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        
                        Text("Current Balance")
                            .font(.caption)
                            
                        Text("$17,298.92")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "arrow.up.circle")
                                Text("Add income")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .background(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "arrow.down.circle")
                                Text("Add Expense")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .background(.pink.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                
                // Recent Activity
                HStack {
                    Text("Recent Activity")
                        .font(.headline)
                    Spacer()
                    
                    Text("See Details")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                
                
                VStack(spacing: 16) {
                    ActivityRowView(name: "Sloik miodu", date: "Today, 16:55", amount: "+$50", type: .income)
                    ActivityRowView(name: "Nowe ramki ul 1", date: "Today, 16:32", amount: "-$120", type: .expense)
                    ActivityRowView(name: "Pokarm dla pszczół maj", date: "Today, 10:12", amount: "-$240", type: .expense)
                    ActivityRowView(name: "Sloik miodu", date: "Yesterday", amount: "+$50", type: .income)
                    ActivityRowView(name: "Sloik miodu", date: "Yesterday", amount: "+$50", type: .income)
                    ActivityRowView(name: "Sloik miodu", date: "Yesterday", amount: "+$50", type: .income)
                    ActivityRowView(name: "Sloik miodu", date: "Yesterday", amount: "+$50", type: .income)
                    ActivityRowView(name: "Sloik miodu", date: "Yesterday", amount: "+$50", type: .income)
                }
                
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Your Expenses")
    }
}

#Preview {
    NavigationStack {
        TestExpenseView()
    }
}



enum ActivityType {
    case expense, income
}

struct ActivityRowView: View {
    
    var name: String
    var date: String
    var amount: String
    var type: ActivityType
    
    var body: some View {
        HStack {
            Circle()
                .fill(type == .income ? Color.orange : Color.pink.opacity(0.8))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: type == .income ? "arrow.up" : "arrow.down")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                )
            
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.medium)
                Text(date)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(amount)
                    .fontWeight(.bold)
                Text(type == .income ? "Income" : "Expense")
                    .font(.caption)
            }
        }
        .padding()
        .background(type == .income ? Color.orange.opacity(0.3) : Color.pink.opacity(0.3))
        .cornerRadius(20)
        //.shadow(radius: 5)
        .contextMenu {
            Button("Delete") {
                
            }
        }
    }
}
