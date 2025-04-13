//
//  SignUpWithEmailView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 05/04/2025.
//

import SwiftUI

struct SignUpWithEmailView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            TextField("Email...", text: $email)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .focused($isTextFieldFocused)
            
            SecureField("Password...", text: $password)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .focused($isTextFieldFocused)
            
            SecureField("Repeat Password...", text: $confirmPassword)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .focused($isTextFieldFocused)
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signUpWithEmail(email: email, password: password)
                        dismiss()
                    } catch {
                        print("nie udalo sie stworzyc usera")
                    }
                }
            
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
            
            Spacer()
        }
        .navigationTitle("Sign Up")
        .padding(.top)
        .toolbar {
            if isTextFieldFocused {
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpWithEmailView()
    }
}
