//
//  HivesServiceProtocol.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 30/05/2025.
//

import Foundation

protocol HivesServiceProtocol {
    func fetchHives(for userId: String) async throws -> [Hive]
    func getHive(hiveId: String) async throws -> Hive
    func addHive(_ hive: Hive) async throws
    func editHive(_ hive: Hive) async throws
    func deleteHive(hiveId: String) async throws
}

