//
//  BeeYardCardView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 24/04/2025.
//

import SwiftUI

struct BeeYardCardView: View {
    
    let imageName: String
    let name: String = "Pasieka na działeczce"
    let location: String = "Dzialka Radoma, ul. Dzialkowa 14"

    var body: some View {
        VStack(spacing: 0) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 160)
                .clipped()
                .cornerRadius(20)

            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .padding(.bottom, 5)

                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                    Text(location)
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
        BeeYardCardView(imageName: "bee-yard")
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<5) { _ in
                    BeeYardCardView(imageName: "bee-yard2")
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
                    BeeYardCardView(imageName: "bee-yard")
                }
            }
            .frame(height: 320)
        }
        .background(Color(.systemGroupedBackground))
        .scrollIndicators(.hidden)
        .edgesIgnoringSafeArea(.horizontal)
    }
}
