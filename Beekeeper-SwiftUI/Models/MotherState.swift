//
//  MotherState.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/05/2025.
//

import Foundation

enum MotherState: String, CaseIterable, Identifiable {
    case active, good
    case old, weakening
    case new, young
    case unknown
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
}
