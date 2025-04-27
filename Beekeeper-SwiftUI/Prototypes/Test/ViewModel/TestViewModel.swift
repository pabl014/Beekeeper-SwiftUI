//
//  TestViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/04/2025.
//

import Foundation

final class TestViewModel: ObservableObject {
    
    @Published private(set) var dbUser: DBUser? = nil
    
    // Dependencies
    private let userService: UserServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(userService: UserServiceProtocol = UserService(), authService: AuthServiceProtocol = AuthenticationService() ) {
        self.userService = userService
        self.authService = authService
    }
    
    @MainActor
    func loadCurrentUser() async throws {
        let authDataResult = authService.getCurrentUser()
        if let authDataResult {
            self.dbUser = try await userService.getUser(userId: authDataResult.uid)
        }
    }
    
    @MainActor
    func addBeeYard() async throws {
        guard let userId = dbUser?.userId else { return }
        try await userService.incrementYardsCount(userId: userId)
        self.dbUser = try await userService.getUser(userId: userId)
    }
    
    
}
