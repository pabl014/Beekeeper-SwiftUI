//
//  HiveHeader.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 24/05/2025.
//

import SwiftUI

struct HiveHeader: View {
    
    let imageUrl: String
    let estDate: Date
    let name: String
    let address: String
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if imageUrl.isEmpty {
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.3)) // Placeholder
                    .frame(height: 250)
                    .cornerRadius(20)
            } else {
                // Jeśli imageUrl nie jest pusty, ładowanie obrazu
                if let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(.gray.opacity(0.3))
                    }
                    .clipped()
                    .frame(height: 250)
                    .cornerRadius(20)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("est. \(estDate.asShortDate)")
                            .foregroundStyle(.secondary)
                        
                        Text(name)
                            .font(.system(size: 28, weight: .bold))
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundStyle(.orange)
                            
                            Text(address)
                                .lineLimit(2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.trailing)
                        
                    }
                }
                .padding(.leading, 4)
                .background(Color(UIColor.secondarySystemBackground).opacity(0.9))
                .cornerRadius(12)
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    HiveHeader(
        imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb", // przykładowe zdjęcie ula z Unsplash
        estDate: Calendar.current.date(byAdding: .day, value: -123, to: Date()) ?? Date(),
        name: "Ul pod lasem",
        address: "Leśna 14, 43-200 Pszczyna"
    )
}
