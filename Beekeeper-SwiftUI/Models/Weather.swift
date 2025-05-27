//
//  Weather.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 27/05/2025.
//

import Foundation

// MARK: - Main Response
struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let main: MainWeather
    let wind: Wind
    let clouds: Clouds
    let sys: System
    let name: String
    let dt: TimeInterval
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - Weather (description)
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Main weather data
struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - System
struct System: Codable {
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}
