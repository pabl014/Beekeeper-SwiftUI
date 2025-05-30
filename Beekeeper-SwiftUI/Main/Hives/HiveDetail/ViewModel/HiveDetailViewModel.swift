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
    @Published var weather: WeatherResponse? = nil
    @Published var isLoading = false
    @Published var isLoadingWeather = false
    @Published var currentHiveId: String? = nil
    
    private var currentUserId: String? {
        authService.currentUserId
    }
    
    // Dependencies:
    private let hivesService: HivesServiceProtocol
    private let authService: AuthServiceProtocol
    private let weatherManager: WeatherManagerProtocol
    
    init(authService: AuthServiceProtocol = AuthenticationService(),
         hivesService: HivesServiceProtocol = HivesService(),
         weatherManager: WeatherManagerProtocol = WeatherManager()) {
        self.authService = authService
        self.hivesService = hivesService
        self.weatherManager = weatherManager
    }
    
    func loadHive(id: String) async {
        isLoading = true
        do {
            hive = try await hivesService.getHive(hiveId: id)
            // Load weather data after hive is loaded
            if let hive = hive {
                await loadWeather(lat: hive.latitude, lon: hive.longitude)
            }
        } catch {
            print("Error loading hive: \(error)")
        }
        isLoading = false
    }
    
    func loadWeather(lat: Double, lon: Double) async {
        isLoadingWeather = true
        do {
            weather = try await weatherManager.getWeatherForLocation(lat: lat, lon: lon)
        } catch {
            print("Error loading weather: \(error)")
            weather = nil
        }
        isLoadingWeather = false
    }
    
    func editHive(
            name: String,
            framesNumber: Int,
            healthState: HealthState,
            motherState: MotherState,
            lastFeedDate: Date,
            lastFeedAmount: Double,
            address: String,
            latitude: String,
            longitude: String
    ) async throws {
       
       guard let hive else {
            return
       }
        
        // Convert string coordinates to Double
        let lat = Double(latitude) ?? 0.0
        let lng = Double(longitude) ?? 0.0
        
        let updatedHive = Hive(
            hiveId: hive.hiveId,
            userId: hive.userId,
            name: name,
            photoUrl: hive.photoUrl,
            estDate: hive.estDate,
            framesNumber: framesNumber,
            healthState: healthState.rawValue,
            motherState: motherState.rawValue,
            lastFeedDate: lastFeedDate,
            lastFeedAmount: lastFeedAmount,
            address: address,
            latitude: lat,
            longitude: lng
        )
        
        try await hivesService.editHive(updatedHive)
    }
}
