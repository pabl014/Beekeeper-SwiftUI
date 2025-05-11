//
//  TestHomeView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 11/05/2025.
//

import SwiftUI

struct TestHomeView: View {
    
    let lat: Double = 52.23072
    let long: Double = 21.016317
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack {
                yards
                
                VStack {
                    HStack {
                        Text("See on map")
                            .font(.title2.bold())
                            .padding(.leading, 16)
                            .padding(.bottom, 8)
                        
                        Spacer(minLength: 0)
                    }
                    //.padding(.horizontal)
                    
                    MapViewForCommunity(locations: sampleLocations)
                        .padding(.horizontal)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("Bee Hives")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    TestHivesList()
                } label: {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("See all")
                    }
                    .font(.headline)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                   
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add new")
                    }
                    .font(.headline)
                }
            }
        }
        
        
    }
    
    var yards: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(0..<5) { _ in
                    NavigationLink {
                        BeeYardDetailView()
                    } label: {
                        BeeYardCardView(imageName: "bee-yard2")
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
    

}

#Preview {
    NavigationStack {
        TestHomeView()
    }
}

struct BeeYardDetailView: View {
    var body: some View {
        Text("DetailView")
    }
}

import MapKit

struct LocationTestModel: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}

let sampleLocations = [
    LocationTestModel(name: "Punkt A", latitude: 53.1305, longitude: 22.9935),   // centrum
    LocationTestModel(name: "Punkt B", latitude: 53.1306, longitude: 22.9934),   // ~13m NE
    LocationTestModel(name: "Punkt C", latitude: 53.1304, longitude: 22.9936),   // ~13m SW
    LocationTestModel(name: "Punkt D", latitude: 53.13055, longitude: 22.9937),  // ~18m E
    LocationTestModel(name: "Punkt E", latitude: 53.13045, longitude: 22.9933)   // ~18m W
]

struct MapViewForCommunity: View {
    
    let locations: [LocationTestModel]
    
    @State private var cameraPosition: MapCameraPosition = .automatic //.region(.countryRegion)
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(locations) { location in
                Marker(
                    location.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                )
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
        }
        .onAppear() {
            if let first = locations.first {
                cameraPosition = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: first.latitude,
                        longitude: first.longitude
                    ),
                    latitudinalMeters: 100,
                    longitudinalMeters: 100
                ))
            }
        }
        .mapStyle(.standard)
        .frame(width: 380, height: 500)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.bottom)
    }
}
