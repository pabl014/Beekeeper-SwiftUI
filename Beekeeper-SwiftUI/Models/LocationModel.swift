//
//  Location.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/05/2025.
//

import Foundation

struct LocationModel: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}

extension LocationModel {
    
   static let mock1 = LocationModel(name: "Punkt A", latitude: 53.1305, longitude: 22.9935)  // centrum
   static let mock2 = LocationModel(name: "Punkt B", latitude: 53.1306, longitude: 22.9934)   // ~13m NE
   static let mock3 = LocationModel(name: "Punkt C", latitude: 53.1304, longitude: 22.9936)  // ~13m SW
   static let mock4 = LocationModel(name: "Punkt D", latitude: 53.13055, longitude: 22.9937)  // ~18m E
   static let mock5 = LocationModel(name: "Punkt E", latitude: 53.13045, longitude: 22.9933)   // ~18m W
    
    static let MOCK_LOCATION_MODELS: [LocationModel] = [
        mock1, mock2, mock3, mock4, mock5
    ]
}
