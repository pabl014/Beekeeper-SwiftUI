//
//  TasksViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import Foundation
import SwiftUI

@MainActor
final class TasksViewModel: ObservableObject {
    
    @Published var tasksArray: [BeeTask] = []
    @Published var isLoading: Bool = false
    
    private let tasksService: TasksServiceProtocol
    private let authService: AuthServiceProtocol
    
    private var currentUserId: String? {
        authService.currentUserId
    }
    
    init(authService: AuthServiceProtocol = AuthenticationService(), tasksService: TasksServiceProtocol = TasksService()) {
        self.authService = authService
        self.tasksService = tasksService
    }
    
    func fetchTasks() async {
        guard let uid = currentUserId else { return }
        
        isLoading = true
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
            await fetchTasks()
        } catch {
            print("Error adding task: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func deleteTask(_ taskId: String) async {
        guard let uid = currentUserId else { return }
        
        isLoading = true
        do {
            try await tasksService.deleteTask(taskId, forUserId: uid)
            await fetchTasks()
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func toggleTaskCompletion(_ task: BeeTask) async {
        isLoading = true
        do {
            try await tasksService.updateTaskCompletion(taskId: task.taskId, isCompleted: !task.isCompleted)
            await fetchTasks()
        } catch {
            print("Error toggling task completion: \(error.localizedDescription)")
        }
        isLoading = false
    }
}
