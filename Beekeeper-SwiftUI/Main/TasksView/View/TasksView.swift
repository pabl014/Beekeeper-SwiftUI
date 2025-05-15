//
//  TasksView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import SwiftUI

struct TasksView: View {
    
    @EnvironmentObject var viewModel: TasksViewModel
    @State private var isAddingTask: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.tasksArray.isEmpty {
                LoadingIndicatorView()
            } else if viewModel.tasksArray.isEmpty {
                noTasks
            } else {
                tasksList
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchTasks(dontShowLoadingIndicator: false)
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
        .overlay {
            if viewModel.isLoading && !viewModel.tasksArray.isEmpty {
                LoadingIndicatorView()
            }
        }
    }
    
    var tasksList: some View {
        List(viewModel.filteredTasks, id: \.taskId) { task in
            TaskCellView(task: task) {
                Task {
                    await viewModel.toggleTaskCompletion(task)
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteTask(task.taskId)
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                .tint(.red)
            }
        }
        .listStyle(PlainListStyle())
        .searchable(text: $viewModel.searchText, prompt: "Search for tasks")
        .overlay {
            if viewModel.filteredTasks.isEmpty && !viewModel.searchText.isEmpty {
                noSearchingResults
            }
        }
    }
    
    var noTasks: some View {
        ContentUnavailableView(
            "No tasks",
            systemImage: "xmark",
            description: Text("Add a task to get started.")
        )
        .padding()
    }
    
    var noSearchingResults: some View {
        ContentUnavailableView(
            "No matching tasks",
            systemImage: "magnifyingglass",
            description: Text("Try a different search term.")
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
