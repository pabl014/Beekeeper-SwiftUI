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
                TabView {
                    SettingsView(showSignInView: $showSignInView)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                    
                    Text("another view")
                        .tabItem {
                            Label("another one", systemImage: "heart")
                        }
                    
                    Text("apple view")
                        .tabItem {
                            Label("applowskie", systemImage: "macpro.gen3.fill")
                        }
                }
            }
        }
        .onAppear {
            self.showSignInView = viewModel.currentUser == nil || viewModel.state == .signedOut
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}
