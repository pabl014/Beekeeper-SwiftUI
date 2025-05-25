//
//  HiveListCell.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/05/2025.
//

import SwiftUI

struct HiveListCell: View {
    
    let imageUrl: String
    let name: String
    let location: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.3))
            }
            .clipped()
            .frame(width: 100, height: 90)
            .cornerRadius(20)
            
            VStack(alignment: .leading) {
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
            
        }
    }
}


#Preview {
    NavigationStack {
        List {
            HiveListCell(
                imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb",
                name: "Ul przy drzewie",
                location: "Dzialeczka, ul. Dzialkowa 14")
            
            HiveListCell(
                imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb",
                name: "Ul przy drzewie",
                location: "Dzialeczka, ul. Dzialkowa 14")
            
            HiveListCell(
                imageUrl: "https://images.unsplash.com/photo-1587300003388-59208cc962cb",
                name: "Ul przy drzewie",
                location: "Dzialeczka, ul. Dzialkowa 14")
        }
        .searchable(text: .constant(""))
    }
}
