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
    @Published var isLoading: Bool = false
    
    // Dependencies
    private let authService: AuthServiceProtocol
    
    // Initializer with dependency injection
    init(authService: AuthServiceProtocol = AuthenticationService()) {
        self.authService = authService
        checkIfUserIsSignedIn()
    }
    
    
    func signInWithEmail(email: String, password: String) async throws {
        
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            self.currentUser = try await authService.signInWithEmail(email: email, password: password)
        } catch let authError as AuthError {
            self.error = authError
            throw authError
        } catch {
            self.error = .signInFailed(description: error.localizedDescription)
            throw error
        }
       
        self.state = .signedIn
    }
    
    func signUpWithEmail(email: String, password: String) async throws {
        
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            self.currentUser = try await authService.signUpWithEmail(email: email, password: password)
        } catch let authError as AuthError {
            self.error = authError
            throw authError
        } catch {
            self.error = .signInFailed(description: error.localizedDescription)
            throw error
        }
    }
    
    func sendPasswordReset(email: String) async {
        
        isLoading = true
        error = nil
        
        do {
            try await authService.sendPasswordReset(email: email)
        } catch {
            self.error = error as? AuthError ?? .passwordResetFailed(description: error.localizedDescription)
        }
        
        isLoading = false
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
