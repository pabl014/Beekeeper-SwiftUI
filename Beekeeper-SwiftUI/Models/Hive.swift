//
//  Hive.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 19/05/2025.
//

import Foundation

struct Hive: Codable, Identifiable {
    let hiveId: String
    let userId: String
    let name: String
    var photoUrl: String
    let estDate: Date
    let framesNumber: Int
    let healthState: String
    let motherState: String
    let lastFeedDate: Date
    let lastFeedAmount: Double
    let address: String
    let latitude: Double
    let longitude: Double
    
    var id: String { hiveId }
}

extension Hive {
    static let mock1 = Hive(
        hiveId: "hive001",
        userId: "user001",
        name: "Ul Różany",
        photoUrl: "https://example.com/hive1.jpg",
        estDate: Date(timeIntervalSince1970: 1672531200), // 1 stycznia 2023
        framesNumber: 10,
        healthState: "Dobra",
        motherState: "Obecna",
        lastFeedDate: Date(timeIntervalSince1970: 1717027200), // 30 maja 2024
        lastFeedAmount: 1.5,
        address: "Łąkowa 12, 00-001 Warszawa",
        latitude: 52.2297,
        longitude: 21.0122
    )

    static let mock2 = Hive(
        hiveId: "hive002",
        userId: "user002",
        name: "Ul Słoneczny",
        photoUrl: "https://example.com/hive2.jpg",
        estDate: Date(timeIntervalSince1970: 1669852800), // 1 grudnia 2022
        framesNumber: 8,
        healthState: "Średnia",
        motherState: "Brak",
        lastFeedDate: Date(timeIntervalSince1970: 1714867200), // 5 maja 2024
        lastFeedAmount: 2.0,
        address: "Polna 8, 00-002 Kraków",
        latitude: 50.0647,
        longitude: 19.9450
    )
}
