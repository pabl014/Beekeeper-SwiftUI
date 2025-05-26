//
//  HiveDetailViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/05/2025.
//

import Foundation

@MainActor
final class HiveDetailViewModel: ObservableObject {
    
    @Published var hive: Hive? = nil
    @Published var isLoading = false
    @Published var currentHiveId: String? = nil
    
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
    
    
    func loadHive(id: String) async {
        
        isLoading = true
        do {
            hive = try await hivesService.getHive(hiveId: id)
        } catch {
            print("Error loading hive: \(error)")
        }
        isLoading = false
    }
}
