//
//  UserServiceProtocol.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 18/05/2025.
//

import Foundation

protocol UserServiceProtocol {
    func createNewUser(user: DBUser) async throws
    func getUser(userId: String) async throws -> DBUser
    func incrementYardsCount(userId: String) async throws
}
