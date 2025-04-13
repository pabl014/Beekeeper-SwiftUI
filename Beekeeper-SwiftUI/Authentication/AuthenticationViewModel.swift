//
//  SignInWithEmailViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var currentUser: User?
    @Published var state: SignInState = .signedOut
    @Published var error: AuthError?
    
    // Dependencies
    private let authService: AuthServiceProtocol
    
    // Initializer with dependency injection
    init(authService: AuthServiceProtocol = AuthenticationService()) {
        self.authService = authService
        checkIfUserIsSignedIn()
    }
    
    
    func signInWithEmail(email: String, password: String) async throws {
        self.currentUser = try await authService.signInWithEmail(email: email, password: password)
        self.state = .signedIn
    }
    
    func signUpWithEmail(email: String, password: String) async throws {
        self.currentUser = try await authService.signUpWithEmail(email: email, password: password)
        self.state = .signedIn
    }
    
    func checkIfUserIsSignedIn() {
        self.currentUser = authService.getCurrentUser()
        
        if currentUser != nil {
            self.state = .signedIn
        } else {
            self.state = .signedOut
        }
    }
    
    func signOut() async {
        do {
            try await authService.signOut()
            self.state = .signedOut
            self.currentUser = nil
        } catch {
            self.error = error as? AuthError ?? .signInFailed(description: error.localizedDescription)
        }
        
    }
    
    
}
