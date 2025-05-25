//
//  HiveDetailView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 19/05/2025.
//

import SwiftUI

struct Hive2DetailView: View {
    
    let hive: Hive
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                HiveHeader(
                    imageUrl: hive.photoUrl,
                    estDate: hive.estDate,
                    name: hive.name,
                    address: hive.address
                )
                
                ExpandableMapView(
                    lat: hive.latitude,
                    long: hive.longitude
                )
                
                // Grid z komórkami danych
                Grid(alignment: .center, horizontalSpacing: 16, verticalSpacing: 16) {
                    // Pierwszy rząd
                    GridRow {
                        // Komórka stanu matki
                        beeMotherCell
                        
                        // Komórka liczby ramek
                        framesCountCell
                    }
                    
                    // Drugi rząd
                    GridRow {
                        // Komórka stanu zdrowia
                        healthStateCell
                        
                        // Komórka z datą założenia
                        establishedCell
                    }
                    
                    // Trzeci rząd - komórka na pełną szerokość
                    GridRow {
                        lastFeedingCell
                    }
                    
                    // Czwarty rząd
                    GridRow {
                        HiveDataCell(
                            title: "Weather",
                            icon: "cloud.sun.fill",
                            iconColor: .yellow,
                            gridCellColumns: 2
                        ) {
                            HStack(spacing: 20) {
                                // Lewa strona - ID ula
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("ID ula:")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    Text(hive.hiveId)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.purple)
                                }
                                
                                Divider()
                                    .frame(height: 60)
                                
                                // Prawa strona - ID użytkownika
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("ID użytkownika:")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    Text(hive.userId)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.indigo)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
                
                // Przycisk akcji
                Button(action: {
                    // Akcja do wykonania
                }) {
                    Text("Edytuj dane ula")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Szczegóły ula")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Określenie koloru dla stanu zdrowia
    func healthColor(_ state: String) -> Color {
        switch state.lowercased() {
        case "dobry", "zdrowy":
            return .green
        case "średni", "przeciętny":
            return .yellow
        case "zły", "chory":
            return .red
        default:
            return .blue
        }
    }
    
    // Określenie ikony dla stanu zdrowia
    func healthSystemImage(_ state: String) -> String {
        switch state.lowercased() {
        case "dobry", "zdrowy":
            return "checkmark.circle.fill"
        case "średni", "przeciętny":
            return "exclamationmark.circle.fill"
        case "zły", "chory":
            return "xmark.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    // Określenie koloru dla stanu matki
    func motherStateColor(_ state: String) -> Color {
        switch state.lowercased() {
        case "aktywna", "dobra":
            return .orange
        case "stara", "słabnąca":
            return .yellow
        case "nowa", "młoda":
            return .green
        default:
            return .gray
        }
    }
    
    // Określenie ikony dla stanu matki
    func motherStateIcon(_ state: String) -> String {
        switch state.lowercased() {
        case "aktywna", "dobra":
            return "star.fill"
        case "stara", "słabnąca":
            return "clock.fill"
        case "nowa", "młoda":
            return "sparkles"
        default:
            return "crown.fill"
        }
    }
    
    var beeMotherCell: some View {
        HiveDataCell(
            title: "Bee mother",
            icon: "crown.fill",
            iconColor: motherStateColor(hive.motherState)
        ) {
            VStack(spacing: 8) {
                Text(hive.motherState)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(motherStateColor(hive.motherState))
                
                Image(systemName: motherStateIcon(hive.motherState))
                    .font(.system(size: 40))
                    .foregroundStyle(motherStateColor(hive.motherState))
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
    }
    
    var framesCountCell: some View {
        HiveDataCell(
            title: "Frames count",
            icon: "square.grid.2x2.fill",
            iconColor: .orange
        ) {
            VStack(spacing: 8) {
                Text("\(hive.framesNumber)")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(.orange)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
    }
    
    var healthStateCell: some View {
        HiveDataCell(
            title: "Health state",
            icon: "heart.fill",
            iconColor: healthColor(hive.healthState)
        ) {
            VStack(spacing: 8) {
                Text(hive.healthState)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(healthColor(hive.healthState))
                
                Image(systemName: healthSystemImage(hive.healthState))
                    .font(.system(size: 40))
                    .foregroundStyle(healthColor(hive.healthState))
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
    }
    
    var establishedCell: some View {
        HiveDataCell(
            title: "Established",
            icon: "calendar",
            iconColor: .blue
        ) {
            VStack(spacing: 8) {
                Text(hive.estDate.asShortDate)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                
                Text(hive.estDate.daysSinceEvent())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
    }
    
    var lastFeedingCell: some View {
        HiveDataCell(
            title: "Last feeding",
            icon: "drop.fill",
            iconColor: .cyan,
            gridCellColumns: 2
        ) {
            HStack(spacing: 32) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(hive.lastFeedDate.asShortDate)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(hive.lastFeedDate.daysSinceEvent())
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                    .frame(height: 70)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Amount:")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    Text("\(hive.lastFeedAmount) kg")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.cyan)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
            .offset(x: -10)
        }
    }
}

//#Preview {
//    NavigationStack {
//        Hive2DetailView(hive: Hive(
//            hiveId: "H-12345",
//            userId: "USR-789",
//            name: "Pszczółka Maja",
//            photoUrl: "https://picsum.photos/300/300",
//            estDate: Calendar.current.date(byAdding: .day, value: -90, to: Date())!,
//            framesNumber: 10,
//            healthState: "Dobry",
//            motherState: "Aktywna",
//            lastFeedDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
//            lastFeedAmount: 2.5,
//            address: "ul. Kwiatowa 15, Pszczelin",
//            location: Location(latitude: 53.232222, longitude: 21.008333)
//        ))
//    }
//}




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
