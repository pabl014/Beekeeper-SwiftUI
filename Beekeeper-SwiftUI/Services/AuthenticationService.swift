//
//  AuthenticationManager.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import Foundation
import FirebaseAuth


protocol AuthServiceProtocol {
    func signInWithEmail(email: String, password: String) async throws -> User
    func signUpWithEmail(email: String, password: String) async throws -> User
    func signOut() async throws
    func getCurrentUser() -> User?
}


final class AuthenticationService: AuthServiceProtocol {
    
    private let firebaseAuth = Auth.auth()
    
    func signInWithEmail(email: String, password: String) async throws -> User {
        do {
            let result = try await firebaseAuth.signIn(withEmail: email, password: password)
            return result.user
        } catch {
            throw AuthError.signInFailed(description: error.localizedDescription)
        }
    }
    
    func signUpWithEmail(email: String, password: String) async throws -> User {
        do {
            let result = try await firebaseAuth.createUser(withEmail: email, password: password)
            return result.user
        } catch {
            throw AuthError.signUpFailed(description: error.localizedDescription)
        }
    }
    
    func signOut() async throws {
        do {
            try firebaseAuth.signOut()
        } catch {
            throw AuthError.signOutFailed(description: error.localizedDescription)
        }
    }
    
    func getCurrentUser() -> User? {
        return firebaseAuth.currentUser
    }
    
}


