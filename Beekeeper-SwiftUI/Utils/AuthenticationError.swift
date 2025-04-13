//
//  AuthenticationError.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 12/04/2025.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case signInFailed(description: String)
    case signUpFailed(description: String)
    case signOutFailed(description: String)
    case userNotFound
    case invalidCredential
    case noRootViewController
    case emailNotVerified
    case passwordResetFailed(description: String)
    case updateProfileFailed(description: String)
    case deleteAccountFailed(description: String)
    case reauthenticationFailed(description: String)
    case updateEmailFailed(description: String)
    case updatePasswordFailed(description: String)
    
    var errorDescription: String? {
        switch self {
        case .signInFailed(_):
            return "Sign in failed: (description)"
        case .signUpFailed(_):
            return "Sign up failed: (description)"
        case .signOutFailed(_):
            return "Sign out failed: (description)"
        case .userNotFound:
            return "User not found"
        case .invalidCredential:
            return "Invalid credentials"
        case .noRootViewController:
            return "Could not find root view controller"
        case .emailNotVerified:
            return "Email not verified"
        case .passwordResetFailed(_):
            return "Password reset failed: (description)"
        case .updateProfileFailed(_):
            return "Failed to update profile: (description)"
        case .deleteAccountFailed(_):
            return "Failed to delete account: (description)"
        case .reauthenticationFailed(_):
            return "Reauthentication required: (description)"
        case .updateEmailFailed(_):
            return "Failed to update email: (description)"
        case .updatePasswordFailed(_):
            return "Failed to update password: (description)"
        }
    }
}
