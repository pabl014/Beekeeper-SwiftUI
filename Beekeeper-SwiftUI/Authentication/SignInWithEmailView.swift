//
//  SignInWithEmailView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import SwiftUI

struct SignInWithEmailView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var showSignInView: Bool
    @State private var email: String = "hello@testing.com"
    @State private var password: String = "qwertyuiop"
    
    var body: some View {
        VStack {
            TextField("Email...", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
            SecureField("Password...", text: $password)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
            Button {
                Task {
                    do {
                        try await viewModel.signInWithEmail(email: email, password: password)
                        showSignInView = false
                    } catch {
                        print("nie udalo sie zalogowac")
                    }
                }
            } label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            .disabled(email.isEmpty || password.isEmpty)
            
            NavigationLink {
                SignUpWithEmailView()
            } label: {
                HStack(spacing: 3) {
                    Text("Don't have an account?")
                    Text("Sign up")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            
            Spacer(minLength: 0)
        }
        .padding(.top)
        .navigationTitle("Sign in with email")
    }
}

#Preview {
    
    NavigationStack {
        SignInWithEmailView(showSignInView: .constant(false))
            .environmentObject( AuthenticationViewModel(
                                    authService: AuthenticationService()
                                )
            )
    }
}
