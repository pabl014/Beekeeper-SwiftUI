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
            
            Text(viewModel.authDataResult?.email ?? "No user logged in")
            Text(viewModel.authDataResult?.displayName ?? "no nickname")
            Text("db user id: \(viewModel.dbUser?.userId ?? "no id db")")
            Text("dbuser email: \(viewModel.dbUser?.email ?? "no email db")")
        }
        .onAppear {
            Task {
                try? await viewModel.loadCurrentUser()
            }
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
