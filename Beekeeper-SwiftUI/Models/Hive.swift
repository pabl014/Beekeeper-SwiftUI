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
    let photoUrl: String
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

