//
//  TaskCellView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import SwiftUI

struct TaskCellView: View {
    
    let task: BeeTask
    var onCirclePressed: ( () -> Void )? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                
                Text("DUE: \(task.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.black)
                
                Text(task.taskName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(4)
            }
            
            Spacer()
            
            Button(action: {
                onCirclePressed?()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 30))
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 8)
        }
        .padding()
        .background(task.isCompleted ? Color.green.opacity(0.3) : Color.orange.opacity(0.3))
        .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    List {
        TaskCellView(task: BeeTask.mock1)
        TaskCellView(task: BeeTask.mock2)
        TaskCellView(task: BeeTask.mock3)
        TaskCellView(task: BeeTask.mock4)
        TaskCellView(task: BeeTask.mock5)
    }
    .listStyle(PlainListStyle())
}
