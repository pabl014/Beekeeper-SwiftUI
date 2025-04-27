//
//  RootView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 05/04/2025.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                TabBarView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            self.showSignInView = viewModel.authDataResult == nil || viewModel.state == .signedOut
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}
