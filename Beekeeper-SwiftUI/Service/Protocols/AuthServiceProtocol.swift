//
//  AuthServiceProtocol.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 18/05/2025.
//

import Foundation

protocol AuthServiceProtocol {
    var currentUserId: String? { get }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel
    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResultModel
    func sendPasswordReset(email: String) async throws
    func signOut() async throws
    func getCurrentUser() -> AuthDataResultModel?
    func signInWithGoogle() async throws -> AuthDataResultModel
    func getProviders() throws -> [AuthProviderOption]
}
