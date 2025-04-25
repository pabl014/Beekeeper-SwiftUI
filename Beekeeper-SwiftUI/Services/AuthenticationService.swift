//
//  AuthenticationManager.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import Foundation
import FirebaseAuth


protocol AuthServiceProtocol {
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel
    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResultModel
    func sendPasswordReset(email: String) async throws
    func signOut() async throws
    func getCurrentUser() -> AuthDataResultModel?
}


final class AuthenticationService: AuthServiceProtocol {
    
    private let firebaseAuth = Auth.auth()
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let result = try await firebaseAuth.signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: result.user)
        } catch {
            throw AuthError.signInFailed(description: error.localizedDescription)
        }
    }
    
    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let result = try await firebaseAuth.createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: result.user)
        } catch {
            throw AuthError.signUpFailed(description: error.localizedDescription)
        }
    }
    
    func sendPasswordReset(email: String) async throws {
        do {
            try await firebaseAuth.sendPasswordReset(withEmail: email)
        } catch {
            throw AuthError.passwordResetFailed(description: error.localizedDescription)
        }
    }
    
    func signOut() async throws {
        do {
            try firebaseAuth.signOut()
        } catch {
            throw AuthError.signOutFailed(description: error.localizedDescription)
        }
    }
    
    func getCurrentUser() -> AuthDataResultModel? {
        
        guard let currentUser = firebaseAuth.currentUser else {
            return nil
        }
        
        return AuthDataResultModel(user: currentUser)
    }
    
}


