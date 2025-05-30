//
//  HiveDetailView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 19/05/2025.
//

import SwiftUI

struct HiveDetailView: View {
    
    @StateObject private var viewModel = HiveDetailViewModel(authService: AuthenticationService(), hivesService: HivesService(), weatherManager: WeatherManager())
    
    let hiveId: String
    
    var body: some View {
        
        Group {
            if viewModel.isLoading {
                ProgressView("Loading hive details...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let hive = viewModel.hive {
                hiveDetailContent(hive: hive)
            } else {
                ContentUnavailableView(
                    "Hive not found",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Unable to load hive details")
                )
            }
        }
        .navigationTitle("Hive Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Jeśli nie mamy danych, załaduj je
            if viewModel.hive == nil {
                await viewModel.loadHive(id: hiveId)
            }
        }
        .refreshable {
            await viewModel.loadHive(id: hiveId)
        }
    }
        
    @ViewBuilder
    private func hiveDetailContent(hive: Hive) -> some View {
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
    
                Grid(alignment: .center, horizontalSpacing: 16, verticalSpacing: 16) {
                    GridRow {
                        beeMotherCell(hive: hive)
                        framesCountCell(hive: hive)
                    }
                    
                    GridRow {
                        healthStateCell(hive: hive)
                        establishedCell(hive: hive)
                    }
                
                    GridRow {
                        lastFeedingCell(hive: hive)
                    }
                
                    GridRow {
                        weatherCell()
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
        .navigationTitle("Hive details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // Determine color based on health state
    func healthColor(_ state: String) -> Color {
        switch state.lowercased() {
        case "good", "healthy":
            return .green
        case "average", "moderate":
            return .yellow
        case "bad", "sick":
            return .red
        default:
            return .blue
        }
    }

    // Determine system image icon based on health state
    func healthSystemImage(_ state: String) -> String {
        switch state.lowercased() {
        case "good", "healthy":
            return "checkmark.circle.fill"
        case "average", "moderate":
            return "exclamationmark.circle.fill"
        case "bad", "sick":
            return "xmark.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }

    
    // Determines the color for queen bee state
    func motherStateColor(_ state: String) -> Color {
        switch state.lowercased() {
        case "active", "good":
            return .orange
        case "old", "weakening":
            return .yellow
        case "new", "young":
            return .green
        default:
            return .gray
        }
    }

    // Determines the icon for queen bee state
    func motherStateIcon(_ state: String) -> String {
        switch state.lowercased() {
        case "active", "good":
            return "star.fill"
        case "old", "weakening":
            return "clock.fill"
        case "new", "young":
            return "sparkles"
        default:
            return "crown.fill"
        }
    }
    
    func beeMotherCell(hive: Hive) -> some View {
        HiveDataCell(
            title: "Bee mother",
            icon: motherStateIcon(hive.motherState),
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
    
    func framesCountCell(hive: Hive) -> some View {
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
    
    func healthStateCell(hive: Hive) -> some View {
        HiveDataCell(
            title: "Health state",
            icon: healthSystemImage(hive.healthState),
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
    
    func establishedCell(hive: Hive) -> some View {
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
    
    func lastFeedingCell(hive: Hive) -> some View {
        HiveDataCell(
            title: "Last feeding",
            icon: "drop.fill",
            iconColor: .cyan,
            gridCellColumns: 2
        ) {
            HStack(alignment: .top, spacing: 20) {
                
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
                    .frame(height: 60)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Amount:")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    Text("\(hive.lastFeedAmount.as2DigitString) kg")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.cyan)
                }
            }
            .padding(.vertical, 8)
        }
    }

    
    func weatherCell() -> some View {
        HiveDataCell(
            title: "Weather",
            icon: weatherIcon(),
            iconColor: weatherIconColor(),
            gridCellColumns: 2
        ) {
            Group {
                if viewModel.isLoadingWeather {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Loading weather...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                } else if let weather = viewModel.weather {
                    HStack(spacing: 20) {
                        // Left side - Temperature and description
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(Int(weather.main.temp.rounded()))°C")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text(weather.weather.first?.description.capitalized ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        
                        Divider()
                            .frame(height: 60)
                        
                        // Right side - Additional info
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundStyle(.blue)
                                    .font(.caption)
                                Text("\(weather.main.humidity)%")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack {
                                Image(systemName: "wind")
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                                Text("\(Int(weather.wind.speed)) m/s")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                } else {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title2)
                                .foregroundStyle(.orange)
                            Text("Weather unavailable")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
            }
        }
    }

    // Add these helper functions to determine weather icon and color:
    func weatherIcon() -> String {
        guard let weather = viewModel.weather?.weather.first else {
            return "cloud.sun.fill"
        }
        
        let main = weather.main.lowercased()
        switch main {
        case "clear":
            return "sun.max.fill"
        case "clouds":
            return "cloud.fill"
        case "rain", "drizzle":
            return "cloud.rain.fill"
        case "thunderstorm":
            return "cloud.bolt.fill"
        case "snow":
            return "cloud.snow.fill"
        case "mist", "fog", "haze":
            return "cloud.fog.fill"
        default:
            return "cloud.sun.fill"
        }
    }

    func weatherIconColor() -> Color {
        guard let weather = viewModel.weather?.weather.first else {
            return .yellow
        }
        
        let main = weather.main.lowercased()
        switch main {
        case "clear":
            return .yellow
        case "clouds":
            return .gray
        case "rain", "drizzle":
            return .blue
        case "thunderstorm":
            return .purple
        case "snow":
            return .white
        case "mist", "fog", "haze":
            return .gray
        default:
            return .yellow
        }
    }
}




