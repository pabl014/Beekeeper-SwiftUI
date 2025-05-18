//
//  TasksViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import Foundation

@MainActor
final class TasksViewModel: ObservableObject {
    
    @Published var tasksArray: [BeeTask] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    var filteredTasks: [BeeTask] {
        guard !searchText.isEmpty else {
            return tasksArray
        }
        
        return tasksArray.filter {
            $0.taskName.lowercased().contains(searchText.lowercased()) ||
            $0.description.lowercased().contains(searchText.lowercased())
        }
    }
    
    private var currentUserId: String? {
        authService.currentUserId
    }
    
    // Dependencies:
    private let tasksService: TasksServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthenticationService(), tasksService: TasksServiceProtocol = TasksService()) {
        self.authService = authService
        self.tasksService = tasksService
    }
    
    func fetchTasks(dontShowLoadingIndicator: Bool) async {
        guard let uid = currentUserId else { return }
        
        if dontShowLoadingIndicator {
            isLoading = false
        } else {
            isLoading = true
        }
        
        do {
            let fetchedTasks = try await tasksService.fetchTasks(forUserId: uid)
            self.tasksArray = fetchedTasks.sorted { $0.dueDate < $1.dueDate }
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func addTask(taskName: String, description: String, dueDate: Date) async {
        guard let uid = currentUserId else { return }
        
        let taskWithTempId = BeeTask(
            taskId: "temp_id",
            userId: uid,
            taskName: taskName,
            description: description,
            dueDate: dueDate,
            isCompleted: false
        )
        
        isLoading = true
        do {
            _ = try await tasksService.addTask(taskWithTempId, forUserId: uid)
            await fetchTasks(dontShowLoadingIndicator: false)
        } catch {
            print("Error adding task: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func deleteTask(_ taskId: String) async {
        guard let uid = currentUserId else { return }
        
        do {
            try await tasksService.deleteTask(taskId, forUserId: uid)
            await fetchTasks(dontShowLoadingIndicator: false)
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func toggleTaskCompletion(_ task: BeeTask) async {
        do {
            try await tasksService.updateTaskCompletion(taskId: task.taskId, isCompleted: !task.isCompleted)
            await fetchTasks(dontShowLoadingIndicator: true)
        } catch {
            print("Error toggling task completion: \(error.localizedDescription)")
        }
    }
}
