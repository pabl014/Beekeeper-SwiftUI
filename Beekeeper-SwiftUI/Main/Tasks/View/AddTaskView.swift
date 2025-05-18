//
//  AddTaskView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: TasksViewModel
    
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var dueDate: Date = Date()
    @State private var showingDatePicker: Bool = false
    @State private var isLoading: Bool = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Task Details") {
                    TextField("Task name", text: $taskName)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            isTextFieldFocused = false
                        }
                    
                    TextField("Description", text: $taskDescription)
                        .lineLimit(4)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            isTextFieldFocused = false
                        }
                }
                
                Section("Due Date") {
                    Button {
                        withAnimation {
                            showingDatePicker.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Due date")
                            Spacer()
                            Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if showingDatePicker {
                        DatePicker("Select a date", selection: $dueDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    }
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addTask()
                    }
                    .disabled(taskName.isEmpty || isLoading)
                }
            }
        }
    }
    
    private func addTask() {
        isLoading = true
        
        Task {
            await viewModel.addTask(
                taskName: taskName.trimmingCharacters(in: .whitespacesAndNewlines),
                description: taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                dueDate: dueDate
            )
            isLoading = false
            dismiss()
        }
    }
}

#Preview {
    AddTaskView()
        .environmentObject(TasksViewModel(
            authService: AuthenticationService(),
            tasksService: TasksService()
        ))
}
