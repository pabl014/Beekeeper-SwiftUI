//
//  TasksServiceProtocol.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 18/05/2025.
//

import Foundation

protocol TasksServiceProtocol {
    func fetchTasks(forUserId userId: String) async throws -> [BeeTask]
    func addTask(_ task: BeeTask, forUserId userId: String) async throws -> String
    func deleteTask(_ taskId: String, forUserId userId: String) async throws
    func updateTaskCompletion(taskId: String, isCompleted: Bool) async throws
}

