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
        Button("Log out") {
            Task {
                await viewModel.signOut()
                showSignInView = true 
            }
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
