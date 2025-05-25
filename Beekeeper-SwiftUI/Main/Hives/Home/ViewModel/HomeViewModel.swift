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
}
