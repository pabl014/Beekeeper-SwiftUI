//
//  SignInWithEmailViewModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var authDataResult: AuthDataResultModel?
    @Published private(set) var dbUser: DBUser? = nil
    @Published var state: SignInState = .signedOut
    @Published var error: AuthError?
    @Published var isLoading: Bool = false
    
    // Dependencies
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    
    // Initializer with dependency injection
    init(authService: AuthServiceProtocol = AuthenticationService(), userService: UserServiceProtocol = UserService() ){
        self.authService = authService
        self.userService = userService
        checkIfUserIsSignedIn()
    }
    
    
    func signInWithEmail(email: String, password: String) async throws {
        
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            self.authDataResult = try await authService.signInWithEmail(email: email, password: password)
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
            self.authDataResult = try await authService.signUpWithEmail(email: email, password: password)
            if let authDataResult {
                let user = DBUser(auth: authDataResult)
                try await userService.createNewUser(user: user)
            }
        } catch let authError as AuthError {
            self.error = authError
            throw authError
        } catch {
            self.error = .signInFailed(description: error.localizedDescription)
            throw error
        }
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = authService.getCurrentUser()
        if let authDataResult {
            self.dbUser = try await userService.getUser(userId: authDataResult.uid)
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
        self.authDataResult = authService.getCurrentUser()
        
        if authDataResult != nil {
            self.state = .signedIn
        } else {
            self.state = .signedOut
        }
    }
    
    func signOut() async {
        do {
            try await authService.signOut()
            GIDSignIn.sharedInstance.signOut()
            self.state = .signedOut
            self.authDataResult = nil
        } catch {
            self.error = error as? AuthError ?? .signInFailed(description: error.localizedDescription)
        }
        
    }
    
    func signInWithGoogle() async throws {
        self.authDataResult = try await authService.signInWithGoogle()
    }
}
