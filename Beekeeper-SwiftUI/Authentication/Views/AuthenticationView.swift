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
            
            VStack {
                Image("funny-bee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Text("Beekeeper")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
            }
            .padding(.bottom, 40)
            .offset(y: -60)
            
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
                .background(.orange)
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
            .environmentObject( AuthenticationViewModel(
                                    authService: AuthenticationService()
                                )
            )
    }
}
