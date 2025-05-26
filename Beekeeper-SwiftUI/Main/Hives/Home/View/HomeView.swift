//
//  HomeView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/05/2025.
//

import SwiftUI
import MapKit

struct HomeView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var isAddingHive: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading hives...")
                        .frame(height: 320)
                } else if viewModel.hivesArray.isEmpty {
                    noHives
                } else {
                    hives
                }
                
                if !viewModel.hivesArray.isEmpty {
                    mapView
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .navigationTitle("Hives")
        .task {
            await viewModel.loadHives()
        }
        .refreshable {
            await viewModel.loadHives()
        }
        .sheet(isPresented: $isAddingHive) {
            AddHiveView()
                .environmentObject(viewModel)
        }
        .toolbar {
            if !viewModel.hivesArray.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: HivesListView()) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("See all")
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isAddingHive = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add hive")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
    
    var hives: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(viewModel.hivesArray) { hive in
                    NavigationLink {
                        HiveDetailView(hiveId: hive.hiveId)
                            .id(hive.hiveId)
                    } label: {
                        HiveCardView(
                            imageUrl: hive.photoUrl,
                            name: hive.name,
                            address: hive.address
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 320)
                }
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
        .scrollIndicators(.visible)
        .edgesIgnoringSafeArea(.horizontal)
    }
    
    var mapView: some View {
        VStack {
            HStack {
                Text("See on map")
                    .font(.title2.bold())
                    .padding(.leading, 16)
                    .padding(.bottom, 8)
                
                Spacer(minLength: 0)
            }
            
            MapViewForHives(locations: viewModel.hivesArray.map { hive in
                LocationModel(
                    name: hive.name,
                    latitude: hive.latitude,
                    longitude: hive.longitude
                )
            })
            .padding(.horizontal)
        }
        .padding(.top, 16)
    }
    
    var noHives: some View {
        ContentUnavailableView(
            "No hives yet",
            systemImage: "house",
            description: Text("Add your first hive to get started")
        )
        .padding()
    }
}
#Preview {
    HomeView()
        .environmentObject(HomeViewModel(
            authService: AuthenticationService(),
            hivesService: HivesService()
        ))
}
