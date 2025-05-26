//
//  HiveDataCell.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/05/2025.
//

import SwiftUI

struct HiveDataCell<Content: View>: View {
    var title: String
    var icon: String
    var iconColor: Color
    var gridCellColumns: Int = 1
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
            }
            content()
        }
        .padding()
        .frame(minHeight: 140)
        .background(Color(UIColor.secondarySystemBackground).opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 5)
        .gridCellColumns(gridCellColumns)
    }
}

#Preview {
    HiveDataCell(
        title: "Honey Production",
        icon: "drop.fill",
        iconColor: .yellow,
        gridCellColumns: 2
    ) {
        VStack(alignment: .leading) {
            Text("25 kg")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text("This season")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    .padding()
}
