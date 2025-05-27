//
//  AddHiveView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/05/2025.
//

import SwiftUI

struct AddHiveView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Form fields
    @State private var name: String = ""
    @State private var estDate: Date = .now
    @State private var framesNumber: Int = 10
    @State private var healthState: HealthState = .good
    @State private var motherState: MotherState = .new
    @State private var lastFeedDate: Date = .now
    @State private var lastFeedAmount: Double = 0.5
    @State private var address: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    @State private var isSaving = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Hive Info")) {
                    TextField("Name", text: $name)
                    
                    DatePicker("Established Date", selection: $estDate, in: ...Date.now, displayedComponents: .date)

                    Stepper("Frames: \(framesNumber)", value: $framesNumber, in: 1...20)
                }
                
                Section(header: Text("Health")) {
                    Picker("Health State", selection: $healthState) {
                        ForEach(HealthState.allCases) { state in
                            Text(state.displayName).tag(state)
                        }
                    }
                    
                    Picker("Queen State", selection: $motherState) {
                        ForEach(MotherState.allCases) { state in
                            Text(state.displayName).tag(state)
                        }
                    }
                }
                
                Section(header: Text("Feeding")) {
                    DatePicker("Last Feed Date", selection: $lastFeedDate, displayedComponents: .date)
                    
                    Stepper("Feed Amount: \(String(format: "%.1f", lastFeedAmount)) L", value: $lastFeedAmount, in: 0...5, step: 0.1)
                }
                
                Section(header: Text("Location")) {
                    TextField("Address", text: $address)
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                        .onChange(of: latitude) { _, newValue in
                            latitude = formatDecimalInput(newValue)
                        }
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                        .onChange(of: longitude) { _, newValue in
                            longitude = formatDecimalInput(newValue)
                        }
                }
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Add Hive")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Button("Create Hive") {
                            createHive()
                            dismiss()
                        }
                        .disabled(name.isEmpty || address.isEmpty)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func createHive() {
        
        if !latitude.isEmpty && !isValidCoordinate(latitude) {
            errorMessage = "Invalid latitude format"
            return
        }
        
        if !longitude.isEmpty && !isValidCoordinate(longitude) {
            errorMessage = "Invalid longitude format"
            return
        }
        
        isSaving = true
        
        Task {
            do {
                try await viewModel.addHive(
                    name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                    estDate: estDate,
                    framesNumber: framesNumber,
                    healthState: healthState,
                    motherState: motherState,
                    lastFeedDate: lastFeedDate,
                    lastFeedAmount: lastFeedAmount,
                    address: address,
                    latitude: latitude,
                    longitude: longitude
                )
                
            } catch {
                errorMessage = "Failed to create hive: \(error.localizedDescription)"
            }
        }
        
        isSaving = false
    }
    
    private func isValidCoordinate(_ coordinate: String) -> Bool {
        let trimmed = coordinate.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try standard conversion
        if Double(trimmed) != nil {
            return true
        }
        
        // Try with comma as decimal separator
        let withDot = trimmed.replacingOccurrences(of: ",", with: ".")
        if Double(withDot) != nil {
            return true
        }
        
        return false
    }
    
    private func formatDecimalInput(_ input: String) -> String {
        // Replace comma with dot for consistent decimal format
        return input.replacingOccurrences(of: ",", with: ".")
    }
}

#Preview {
    NavigationStack {
        AddHiveView()
    }
}
