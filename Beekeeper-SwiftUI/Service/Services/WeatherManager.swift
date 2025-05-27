//
//  WeatherManager.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 27/05/2025.
//

import Foundation

protocol WeatherManagerProtocol {
    func getWeatherForLocation(lat: Double, lon: Double) async throws -> WeatherResponse
}

final class WeatherManager: WeatherManagerProtocol {
    
    // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    
    private let apiKey: String = Secrets.openWeatherApiKey
    private let openWeatherUrl: String = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherForLocation(lat: Double, lon: Double) async throws -> WeatherResponse {
        
        let endpoint = "\(openWeatherUrl)?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            print("Decoding weather failed: \(error)")
            throw error
        }
    }
    
}
