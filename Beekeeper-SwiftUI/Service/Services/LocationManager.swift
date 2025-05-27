//
//  LocationManager.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 27/05/2025.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocation, Error>) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @MainActor
    func requestLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            requestLocation { result in
                continuation.resume(with: result)
            }
        }
    }
    
    @MainActor
    private func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        guard locationManager.authorizationStatus != .denied else {
            completion(.failure(LocationError.accessDenied))
            return
        }
        
        locationCompletion = completion
        isLoading = true
        errorMessage = nil
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            completion(.failure(LocationError.accessDenied))
        }
    }
    
    @MainActor
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        isLoading = false
        locationCompletion = nil
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        currentLocation = location
        isLoading = false
        locationCompletion?(.success(location))
        locationCompletion = nil
        
        // Stop updating location after getting the first result
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = LocationError.locationUnavailable.errorDescription
        locationCompletion?(.failure(error))
        locationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if locationCompletion != nil {
                locationManager.requestLocation()
            }
        case .denied, .restricted:
            isLoading = false
            errorMessage = LocationError.accessDenied.errorDescription
            locationCompletion?(.failure(LocationError.accessDenied))
            locationCompletion = nil
        default:
            break
        }
    }
}

// MARK: - LocationError
enum LocationError: LocalizedError {
    case accessDenied
    case locationUnavailable
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Location access denied. You can enable location services in Settings."
        case .locationUnavailable:
            return "Unable to determine current location."
        }
    }
}
