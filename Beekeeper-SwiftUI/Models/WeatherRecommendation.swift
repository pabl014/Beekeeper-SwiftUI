//
//  WeatherRecommendation.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 30/05/2025.
//

import Foundation

struct WeatherRecommendation {
    let type: WeatherRecommendationType
    let title: String
    let description: String
    let actions: [String]
}

extension WeatherRecommendation {
    static let mock: WeatherRecommendation = WeatherRecommendation(
        type: .excellent,
        title: "Ideal conditions",
        description: "Perfect weather for hive inspection: moderate temperature, low wind, and clear sky.",
        actions: [
            "Inspect all frames thoroughly",
            "Check queen and brood pattern",
            "Replenish feed if necessary",
            "Clean hive entrances"
        ]
    )
}

enum WeatherRecommendationType {
    case excellent
    case good
    case caution
    case avoid
    
    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "blue"
        case .caution: return "orange"
        case .avoid: return "red"
        }
    }
    
    var icon: String {
        switch self {
        case .excellent: return "checkmark.circle.fill"
        case .good: return "checkmark.circle"
        case .caution: return "exclamationmark.triangle.fill"
        case .avoid: return "xmark.circle.fill"
        }
    }
}
