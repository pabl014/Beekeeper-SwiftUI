//
//  Task.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 27/04/2025.
//

import Foundation

struct BeeTask {
    let taskId: String
    let yardId: String
    let taskName: String
    let description: String
    let dueDate: Date
    let isCompleted: Bool
}

extension BeeTask {
    
    static let mock1 = BeeTask(
        taskId: UUID().uuidString,
        yardId: UUID().uuidString,
        taskName: "Sprawdzić ramki",
        description: "Sprawdzić, czy ramki w ulu są pełne miodu i czy nie ma oznak chorób.",
        dueDate: Date(),
        isCompleted: false
    )
    
    static let mock2 = BeeTask(
        taskId: UUID().uuidString,
        yardId: UUID().uuidString,
        taskName: "Nakarmić pszczoły w ulu przy drzewie",
        description: "Dać 2L syropu cukrowego na wieczór.",
        dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
        isCompleted: true
    )
    
    static let mock3 = BeeTask(
        taskId: UUID().uuidString,
        yardId: UUID().uuidString,
        taskName: "Wymienić matkę pszczelą",
        description: "Sprawdzić kondycję starej matki i przygotować nową.",
        dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
        isCompleted: false
    )
    
    static let mock4 = BeeTask(
        taskId: UUID().uuidString,
        yardId: UUID().uuidString,
        taskName: "Przygotować ule na zimę",
        description: "Izolacja, zmniejszenie wylotków, dodatkowe dokarmianie.",
        dueDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date(),
        isCompleted: false
    )
    
    static let mock5 = BeeTask(
        taskId: UUID().uuidString,
        yardId: UUID().uuidString,
        taskName: "Sprawdzić leczenie warrozy",
        description: "Kontrola skuteczności zastosowanego leczenia.",
        dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
        isCompleted: true
    )
    
    static let MOCK_TASKS: [BeeTask] = [
        mock1, mock2, mock3, mock4, mock5
    ]
}
