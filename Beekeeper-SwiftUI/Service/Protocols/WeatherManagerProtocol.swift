//
//  WeatherManagerProtocol.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 30/05/2025.
//

import Foundation

protocol WeatherManagerProtocol {
    func getWeatherForLocation(lat: Double, lon: Double) async throws -> WeatherResponse
}
