//
//  HiveDetailView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 19/05/2025.
//

import SwiftUI

struct HiveDetailView: View {
    
    @StateObject private var viewModel = HiveDetailViewModel(authService: AuthenticationService(), hivesService: HivesService())
    
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
                    
                    Text("\(hive.lastFeedAmount.as2DigitString) kg")
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




