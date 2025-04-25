//
//  AuthenticationView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

import AuthenticationServices

struct AuthenticationView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            VStack {
                Image("funny-bee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Text("Beekeeper")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
            }
            .padding(.bottom, 40)
            
            NavigationLink {
                SignInWithEmailView(showSignInView: $showSignInView)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                    
                    Text("Email")
                        
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide,state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInWithGoogle()
                        showSignInView = false
                    } catch {
                        print("Błąd logowania przez Google:", error.localizedDescription)
                        //  viewModel.error = ...
                    }
                }
            }
            
            SignInWithAppleButton { request in
                
            } onCompletion: { result in
                
            }
            .frame(height: 45)
        }
        .padding()
        .navigationTitle(Text("Sign In"))
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
            .environmentObject( AuthenticationViewModel(
                                    authService: AuthenticationService()
                                )
            )
    }
}
