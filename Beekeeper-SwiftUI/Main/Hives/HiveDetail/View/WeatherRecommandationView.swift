//
//  WeatherRecommandationView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 30/05/2025.
//

import SwiftUI

struct WeatherRecommendationView: View {
    
    let recommendation: WeatherRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: recommendation.type.icon)
                    .foregroundStyle(recommendation.type.swiftUIColor)
                    .font(.title2)
                
                Text(recommendation.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text(recommendation.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if !recommendation.actions.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Recommendations:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    ForEach(recommendation.actions.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundColor(recommendation.type.swiftUIColor)
                                .fontWeight(.bold)
                            
                            Text(recommendation.actions[index])
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(recommendation.type.swiftUIColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(recommendation.type.swiftUIColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    WeatherRecommendationView(recommendation: WeatherRecommendation.mock)
        .padding()
}


extension WeatherRecommendationType {
    var swiftUIColor: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .caution: return .orange
        case .avoid: return .red
        }
    }
}
