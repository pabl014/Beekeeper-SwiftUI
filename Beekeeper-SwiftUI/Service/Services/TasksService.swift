//
//  TasksService.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import Foundation
import FirebaseFirestore

final class TasksService: TasksServiceProtocol {

    private let db = Firestore.firestore()
    private let tasksCollection = "tasks"

    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func addTask(_ task: BeeTask, forUserId userId: String) async throws -> String {
        
        let docRef = db.collection(tasksCollection).document()
        
        let taskWithFirestoreId = BeeTask(
            taskId: docRef.documentID,
            userId: task.userId,
            taskName: task.taskName,
            description: task.description,
            dueDate: task.dueDate,
            isCompleted: task.isCompleted
        )
        
        try docRef.setData(from: taskWithFirestoreId, encoder: encoder)
        
        return docRef.documentID
    }

    func fetchTasks(forUserId userId: String) async throws -> [BeeTask] {
        let snapshot = try await db.collection(tasksCollection)
            .whereField("user_id", isEqualTo: userId)
            .getDocuments()

        return try snapshot.documents.map {
            try $0.data(as: BeeTask.self, decoder: decoder)
        }
    }

    func deleteTask(_ taskId: String, forUserId userId: String) async throws {
        try await db.collection(tasksCollection)
            .document(taskId)
            .delete()
    }
    
    func updateTaskCompletion(taskId: String, isCompleted: Bool) async throws {
        try await db.collection(tasksCollection)
            .document(taskId)
            .updateData([
                "is_completed": isCompleted
            ])
    }
}
