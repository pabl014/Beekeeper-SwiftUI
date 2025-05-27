//
//  HealthState.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/05/2025.
//

import Foundation

enum HealthState: String, CaseIterable, Identifiable {
    case good, healthy
    case average, moderate
    case bad, sick
    case unknown
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
}
