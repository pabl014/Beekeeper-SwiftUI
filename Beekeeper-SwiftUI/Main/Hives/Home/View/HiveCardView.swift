//
//  BeeYardCardView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 24/04/2025.
//

import SwiftUI

struct HiveCardView: View {
    
    var imageUrl: String? = "https://images.unsplash.com/photo-1587300003388-59208cc962cb"
    var name: String? = "Ul przy drzewie"
    var address: String? = "Dzialeczka, ul. Dzialkowa 14"

    var body: some View {
        VStack(spacing: 0) {
            
            AsyncImage(url: URL(string: imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.3))
            }
            .clipped()
            .frame(width: 300, height: 160)
            .cornerRadius(20)

            VStack(alignment: .leading, spacing: 8) {
                Text(name ?? "unknown")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .padding(.bottom, 5)

                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                    Text(address ?? "unknown")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .frame(width: 300, height: 300)
        .padding(.horizontal)
    }
}

#Preview {
    
    ScrollView(.vertical) {
        HiveCardView()
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<5) { _ in
                    HiveCardView(imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb")
                }
            }
            .frame(height: 320)
        }
        .background(Color(.systemGroupedBackground))
        .scrollIndicators(.hidden)
        .edgesIgnoringSafeArea(.horizontal)
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<5) { _ in
                    HiveCardView(imageUrl: "")
                }
            }
            .frame(height: 320)
        }
        .background(Color(.systemGroupedBackground))
        .scrollIndicators(.hidden)
        .edgesIgnoringSafeArea(.horizontal)
    }
}
