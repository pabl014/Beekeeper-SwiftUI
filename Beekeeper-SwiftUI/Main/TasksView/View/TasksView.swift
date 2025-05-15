//
//  TasksView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import SwiftUI

struct TasksView: View {
    
    @EnvironmentObject var viewModel: TasksViewModel
    @State private var searchText: String = ""
    @State private var isAddingTask: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.tasksArray.isEmpty {
                noResults
            } else {
                List(viewModel.tasksArray, id: \.taskId) { task in
                    TaskCellView(task: task) {
                        Task {
                            await viewModel.toggleTaskCompletion(task)
                        }
                    }
                    .swipeActions(edge:.leading, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteTask(task.taskId)
                            }
                        } label: {
                            Label("Delete", systemImage: "xmark.bin.fill")
                        }
                        .tint(.red)
                    }
                }
                .listStyle(PlainListStyle())
                .searchable(text: $searchText)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchTasks()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isAddingTask = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .tint(.orange)
                }
            }
        }
        .sheet(isPresented: $isAddingTask) {
            AddTaskView()
                .environmentObject(viewModel)
                .presentationDetents([.medium, .large])
        }
        .navigationTitle(Text("Tasks"))
    }
    
    var noResults: some View {
        ContentUnavailableView(
            "No tasks",
            systemImage: "xmark.circle",
            description: Text("Add a task to get started.")
        )
    }
}

#Preview {
    NavigationStack {
        TasksView()
            .environmentObject(TasksViewModel(
                authService: AuthenticationService(),
                tasksService: TasksService()
            ))
    }
}
