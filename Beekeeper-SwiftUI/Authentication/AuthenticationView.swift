//
//  AuthenticationView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            NavigationLink {
                SignInWithEmailView(showSignInView: $showSignInView)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                    
                    Text("Email")
                        
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .navigationTitle(Text("Sign In"))
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
