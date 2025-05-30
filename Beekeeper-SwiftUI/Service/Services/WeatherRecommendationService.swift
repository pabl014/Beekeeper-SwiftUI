//
//  WeatherRecommendationService.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 30/05/2025.
//

import Foundation

final class WeatherRecommendationService {
    
    static func getRecommendation(for weather: WeatherResponse) -> WeatherRecommendation {
        
        let temp = weather.main.temp
        let humidity = weather.main.humidity
        let windSpeed = weather.wind.speed
        let weatherCondition = weather.weather.first?.main ?? ""
        
        // Rain or thunderstorm - avoid
        if weatherCondition.contains("Rain") || weatherCondition.contains("Thunderstorm") || weatherCondition.contains("Drizzle") {
            return WeatherRecommendation(
                type: .avoid,
                title: "Avoid hive inspection",
                description: "Rainy weather. Bees are aggressive and stressed during rainfall.",
                actions: [
                    "Postpone hive inspection",
                    "Check hive seals for tightness",
                    "Prepare additional protection"
                ]
            )
        }
        
        // Snow or very cold
        if weatherCondition.contains("Snow") || temp < 8 {
            return WeatherRecommendation(
                type: .avoid,
                title: "Too cold for hive work",
                description: "Temperature below 8°C. Bees are inactive and opening hives can weaken them.",
                actions: [
                    "Wait for warmer weather",
                    "Only inspect hive exteriors",
                    "Prepare winter protection"
                ]
            )
        }
        
        // Very hot
        if temp > 35 {
            return WeatherRecommendation(
                type: .caution,
                title: "Extremely hot weather",
                description: "Temperature above 35°C. Bees may become more aggressive.",
                actions: [
                    "Work early in the morning or late evening",
                    "Use more smoke",
                    "Check hive ventilation",
                    "Provide shade for hives"
                ]
            )
        }
        
        // Strong wind
        if windSpeed > 8 {
            return WeatherRecommendation(
                type: .caution,
                title: "Strong wind",
                description: "Wind over 8 m/s hinders bee flights and makes work difficult.",
                actions: [
                    "Be cautious when opening hives",
                    "Secure frames against falling",
                    "Check hive stability"
                ]
            )
        }
        
        // Fog or high humidity
        if weatherCondition.contains("Mist") || weatherCondition.contains("Fog") || humidity > 90 {
            return WeatherRecommendation(
                type: .caution,
                title: "High humidity",
                description: "Fog or humidity above 90%. Bees are less active.",
                actions: [
                    "Check hive ventilation",
                    "Control moisture levels in hives",
                    "Consider a brief inspection"
                ]
            )
        }
        
        // Ideal conditions
        if temp >= 15 && temp <= 25 && windSpeed < 5 && humidity < 70 &&
           (weatherCondition.contains("Clear") || weatherCondition.contains("Clouds")) {
            return WeatherRecommendation(
                type: .excellent,
                title: "Ideal conditions",
                description: "Temperature 15-25°C, light wind, low humidity. Perfect time for hive work.",
                actions: [
                    "Perform a full hive inspection",
                    "Check queen status",
                    "Add frames if needed",
                    "Monitor bee health"
                ]
            )
        }
        
        // Good conditions
        if temp >= 12 && temp <= 30 && windSpeed < 7 &&
           (weatherCondition.contains("Clear") || weatherCondition.contains("Clouds")) {
            return WeatherRecommendation(
                type: .good,
                title: "Good conditions",
                description: "Weather supports beekeeping activities. Safe to open hives.",
                actions: [
                    "Conduct a routine inspection",
                    "Check food supplies",
                    "Monitor for pests",
                    "Refill feeders if necessary"
                ]
            )
        }
        
        // Moderate conditions - default
        return WeatherRecommendation(
            type: .caution,
            title: "Moderate conditions",
            description: "Conditions are not ideal, but work is possible with extra caution.",
            actions: [
                "Limit time spent at the hives",
                "Use extra calming smoke",
                "Be especially careful",
                "Observe bee behavior closely"
            ]
        )
    }
}

