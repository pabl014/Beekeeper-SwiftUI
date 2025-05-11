//
//  TestHivesList.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 11/05/2025.
//

import SwiftUI

struct TestHivesList: View {
    var body: some View {
        List {
            HiveListCell(imageName: "bee-yard")
            HiveListCell(imageName: "bee-yard")
            HiveListCell(imageName: "bee-yard")
        }
        .searchable(text: .constant(""))
    }
}

#Preview {
    TestHivesList()
}

struct HiveListCell: View {
    
    let imageName: String
    let name: String = "Maly ul nr 7"
    let location: String = "Dzialeczka, ul. Dzialkowa 14"
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 90)
                .clipped()
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
