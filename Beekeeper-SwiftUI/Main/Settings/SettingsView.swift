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
            if let user = viewModel.dbUser {
                Section {
                    HStack(spacing: 16) {
                        Text(firstLetterOrBee(from: user.displayName))
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(.orange)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text(user.displayName ?? "no name")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email ?? "no email")
                                .font(.footnote)
                                .tint(.gray)
                            
                            Text("Joined: \(user.dateCreated?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")")
                                .font(.caption)
                                .tint(.gray)
                        }
                    }
                }
            }
            
            Section("General") {
                HStack(spacing: 12) {
                    Image(systemName: "gear")
                        .imageScale(.small)
                        .font(.title)
                        .foregroundStyle(.orange)
                    
                    Text("Version")
                        .font(.subheadline)
                        .tint(.orange)
                    
                    Spacer(minLength: 0)
                    
                    Text("1.0.0")
                        .tint(.gray)
                }
            }
            
            Section("Account") {
                
                Button {
                    Task {
                        await viewModel.signOut()
                        showSignInView = true
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.left.circle.fill")
                            .imageScale(.small)
                            .font(.title)
                            .foregroundStyle(.red)
                        
                        Text("Log out")
                            .font(.subheadline)
                            .tint(.red)
                    }
                }
            }
        }
        .onAppear {
            Task {
                try? await viewModel.loadCurrentUser()
            }
        }
    }
    
    func firstLetterOrBee(from displayName: String?) -> String {
        if let name = displayName, let firstChar = name.first {
            return String(firstChar).uppercased()
        } else {
            return "BEE"
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
        .environmentObject( AuthenticationViewModel(
                                authService: AuthenticationService()
                            )
        )
}
