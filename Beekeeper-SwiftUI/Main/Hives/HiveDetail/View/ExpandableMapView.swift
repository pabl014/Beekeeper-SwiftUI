//
//  ExpandableMapView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 19/05/2025.
//

import SwiftUI
import MapKit

struct ExpandableMapView: View {
    
    @State private var isExpanded: Bool = false
    
    let lat: Double
    let long: Double
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    self.isExpanded.toggle()
                }
           } label: {
                HStack {
                    Text("See on map")
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                .padding()
            }
            
            if isExpanded {
                MapViewForOneHive(latitude: lat, longitude: long)
            }
        }
        .background(.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

#Preview {
    ExpandableMapView(lat: 52.23072, long: 21.016317)
}


struct MapViewForOneHive: View {
    
    let latitude: Double
    let longitude: Double
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $cameraPosition) {
            Marker(
                "\("Location")",
                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            )
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
        }
        .onAppear() {
            cameraPosition = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longitude
                ),
                latitudinalMeters: 100,
                longitudinalMeters: 100)
            )
        }
        .mapStyle(.hybrid)
        .frame(width: 350, height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.bottom)
    }
}
