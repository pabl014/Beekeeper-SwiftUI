//
//  TaskView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 27/04/2025.
//

import SwiftUI

struct TaskView: View {
    
    @State private var searchText: String = ""
    
    var body: some View {
        
        List(BeeTask.MOCK_TASKS, id: \.taskId) { task in
            TaskCellView(task: task) {
                print("isCompletedToggled for task: \(task.taskName)")
            }
            .swipeActions(edge:.leading, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    Task {
                        print("delete action here")
                    }
                } label: {
                    Label("Delete", systemImage: "xmark.bin.fill")
                }
                .tint(.red)
            }
        }
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("sheet here")
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .tint(.orange)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(Text("Tasks"))
    }
}

#Preview {
    NavigationStack {
        TaskView()
    }
}

struct TaskCellView: View {

    let task: BeeTask
    var onCirclePressed: (() -> Void)? = nil
    
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
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(action: {
                onCirclePressed?()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 30))
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 8)
        }
        .padding()
        .background(task.isCompleted ? Color.green.opacity(0.3) : Color.orange.opacity(0.3))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        //.padding(.horizontal)
    }
}
