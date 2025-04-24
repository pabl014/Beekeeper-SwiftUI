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
    @State private var password: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        VStack {
            TextField("Email...", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .focused($isTextFieldFocused)
            
            SecureField("Password...", text: $password)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .focused($isTextFieldFocused)
            
            HStack() {
                NavigationLink {
                    ForgotPasswordView()
                } label : {
                    Text("I forgot my password")
                        .font(.system(size: 14))
                        .foregroundStyle(.orange)
                }
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.top, 2)
            .padding(.bottom, -12)
            
            Button {
                Task {
                    do {
                        try await viewModel.signInWithEmail(email: email, password: password)
                        showSignInView = false
                    } catch {
                        showErrorAlert = true 
                        print("nie udalo sie zalogowac")
                    }
                }
            } label: {
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                } else {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
            }
            .disabled(email.isEmpty || password.isEmpty || !email.isValidEmail)
            
            NavigationLink {
                SignUpWithEmailView()
            } label: {
                HStack(spacing: 3) {
                    Text("Don't have an account?")
                    Text("Sign up")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
                .foregroundStyle(.orange)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.top)
        .navigationTitle("Sign in with email")
        .toolbar {
            if isTextFieldFocused {
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") {
                showErrorAlert = false
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An unknown error occurred")
        }
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
