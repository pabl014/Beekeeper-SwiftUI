//
//  HomeViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/05/2025.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var hivesArray: [Hive] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var currentUserId: String? {
        authService.currentUserId
    }
    
    // Dependencies:
    private let hivesService: HivesServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthenticationService(), hivesService: HivesServiceProtocol = HivesService()) {
        self.authService = authService
        self.hivesService = hivesService
    }
    
    
    func loadHives() async {
        guard let userId = currentUserId else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            hivesArray = try await hivesService.fetchHives(for: userId)
        } catch {
            errorMessage = "Failed to load hives: \(error.localizedDescription)"
            print("Error loading hives: \(error)")
        }
        
        isLoading = false
    }
    
    func addHive(
        name: String,
        estDate: Date,
        framesNumber: Int,
        healthState: HealthState,
        motherState: MotherState,
        lastFeedDate: Date,
        lastFeedAmount: Double,
        address: String,
        latitude: String,
        longitude: String
    ) async throws {
        guard let userId = currentUserId else {
            errorMessage = "User not authenticated"
            return
        }
        
        // Convert string coordinates to Double
        let lat = Double(latitude) ?? 0.0
        let lng = Double(longitude) ?? 0.0
        
        let newHive = Hive(
            hiveId: "", // Will be set by the service
            userId: userId,
            name: name,
            photoUrl: "", // Empty for now, can be added later
            estDate: estDate,
            framesNumber: framesNumber,
            healthState: healthState.rawValue,
            motherState: motherState.rawValue,
            lastFeedDate: lastFeedDate,
            lastFeedAmount: lastFeedAmount,
            address: address,
            latitude: lat,
            longitude: lng
        )
        
        let _ = try await hivesService.addHive(newHive)
        
        // Reload hives to reflect the new addition
        await loadHives()
    }
    
    func deleteHive(_ hive: Hive) async {
        do {
            try await hivesService.deleteHive(hiveId: hive.hiveId)
            
            if let index = hivesArray.firstIndex(where: { $0.hiveId == hive.hiveId }) {
                hivesArray.remove(at: index)
            }
            await loadHives()
        } catch {
            errorMessage = "Failed to delete hive: \(error.localizedDescription)"
            print("Error deleting hive: \(error)")
        }
    }
}
