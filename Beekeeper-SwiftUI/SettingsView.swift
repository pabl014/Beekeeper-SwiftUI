//
//  SettingsView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 12/04/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    await viewModel.signOut()
                    showSignInView = true
                }
            }
            
            Text(viewModel.currentUser?.email ?? "No user logged in")
            Text(viewModel.currentUser?.displayName ?? "no nickname")
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
        .environmentObject( AuthenticationViewModel(
                                authService: AuthenticationService()
                            )
        )
}
