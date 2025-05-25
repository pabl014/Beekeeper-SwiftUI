//
//  MapViewForHives.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/05/2025.
//

import SwiftUI
import MapKit

struct MapViewForHives: View {
    
    let locations: [LocationModel]
    
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
        .mapStyle(.hybrid)
        .frame(width: 380, height: 500)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.bottom)
    }
}

#Preview {
    MapViewForHives(locations: LocationModel.MOCK_LOCATION_MODELS)
}
