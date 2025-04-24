//
//  ForgotPasswordView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 13/04/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var emailForPasswordReset: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var showResetPasswordConfirmation: Bool = false
    
    @State private var showErrorAlert: Bool = false
   
    var body: some View {
        VStack {
            Text("Please enter your email address to reset your password. You will receive an email with instructions on how to reset your password.")
                .font(.body)
                .padding()
                .offset(x: -10)
            
            TextField("Enter Your Email...", text: $emailForPasswordReset)
                .keyboardType(.emailAddress)
                .padding()
                .frame(height: 55)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .focused($isTextFieldFocused)
            
            Button(action: {
                Task {
                    await viewModel.sendPasswordReset(email: emailForPasswordReset)
                    if viewModel.error != nil {
                        showErrorAlert = true
                    } else {
                        showResetPasswordConfirmation = true
                    }
                }
            }) {
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
                    Text("Reset password")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
            }
            .disabled(emailForPasswordReset.isEmpty || !emailForPasswordReset.isValidEmail)
        
            Spacer(minLength: 0)
            
        }
        .navigationTitle("Reset Password")
        .toolbar {
            if isTextFieldFocused {
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
        .alert("Reset password email sent", isPresented: $showResetPasswordConfirmation) {
            Button("OK") {
                showResetPasswordConfirmation = false
                dismiss()
            }
        } message: {
            Text("If an account exists for \(emailForPasswordReset), you will receive an email with instructions to reset your password.")
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
        ForgotPasswordView()
            .environmentObject( AuthenticationViewModel(
                                    authService: AuthenticationService()
                                )
            )
    }
}
