//
//  AuthenticationManager.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift


protocol AuthServiceProtocol {
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel
    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResultModel
    func sendPasswordReset(email: String) async throws
    func signOut() async throws
    func getCurrentUser() -> AuthDataResultModel?
    func signInWithGoogle() async throws -> AuthDataResultModel
    func getProviders() throws -> [AuthProviderOption]
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
    
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = firebaseAuth.currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        // This is an array, because every user has the ability to sign in with more than one provider.
        // You can have your users sign in with email and they can also connect their gmail account, so that's why one user can have many providers
        for provider in providerData {
            //print(provider.providerID)
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        //print(providers)
        return providers
    }
    
}


//MARK: - Google sign in
extension AuthenticationService {
    
    @MainActor
    func signInWithGoogle() async throws -> AuthDataResultModel {
        // Check for existing sign-in
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            do {
                let result = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                return try await authenticateGoogleUser(for: result)
            } catch {
                throw AuthError.signInFailed(description: error.localizedDescription)
            }
        } else {
            // Get the root view controller
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                throw AuthError.noRootViewController
            }
            
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                return try await authenticateGoogleUser(for: result.user)
            } catch {
                throw AuthError.signInFailed(description: error.localizedDescription)
            }
        }
    }
    
//    private func authenticateGoogleUser(for user: GIDGoogleUser?) async throws -> AuthDataResultModel {
//        guard let idToken = user?.idToken?.tokenString else {
//            throw AuthError.invalidCredential
//        }
//        
//        let credential = GoogleAuthProvider.credential(
//            withIDToken: idToken,
//            accessToken: user?.accessToken.tokenString ?? ""
//        )
//        
//        do {
//            let result = try await Auth.auth().signIn(with: credential)
//            
//            
//            //  Update displayName with "name + surname"
//            let fullName = user?.profile?.name ?? "Google User"
//            let changeRequest = result.user.createProfileChangeRequest()
//            changeRequest.displayName = fullName
//            try await changeRequest.commitChanges()
//            
//            // Save user to Firestore
//            let dbUser = DBUser(auth: AuthDataResultModel(user: result.user))
//            let userService = UserService()
//            try await userService.createNewUser(user: dbUser)
//            
//            return AuthDataResultModel(user: result.user)
//            
//        } catch {
//            throw AuthError.signInFailed(description: error.localizedDescription)
//        }
//    }
    
    private func authenticateGoogleUser(for user: GIDGoogleUser?) async throws -> AuthDataResultModel {
        guard let idToken = user?.idToken?.tokenString else {
            throw AuthError.invalidCredential
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user?.accessToken.tokenString ?? ""
        )
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            
            //  Update displayName with "name + surname"
            let fullName = user?.profile?.name ?? "Google User"
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            try await changeRequest.commitChanges()
            
            // Save user to Firestore tylko jeśli go NIE MA
            let dbUser = DBUser(auth: AuthDataResultModel(user: result.user))
            let userService = UserService()
            
            do {
                _ = try await userService.getUser(userId: dbUser.userId)
                // Użytkownik istnieje - nic nie robimy
            } catch {
                // Jeśli użytkownika nie ma w bazie -> tworzymy
                try await userService.createNewUser(user: dbUser)
            }
            
            return AuthDataResultModel(user: result.user)
            
        } catch {
            throw AuthError.signInFailed(description: error.localizedDescription)
        }
    }

}

