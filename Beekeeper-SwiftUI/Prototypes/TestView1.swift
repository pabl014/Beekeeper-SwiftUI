//
//  TestView1.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/04/2025.
//

import SwiftUI

struct TestView1: View {
    
    @EnvironmentObject var viewModel: TestViewModel
    
    var body: some View {
        VStack {
            Text("db user id: \(viewModel.dbUser?.userId ?? "no id db")")
            Text("dbuser email: \(viewModel.dbUser?.email ?? "no email db")")
            
            Button {
                Task {
                    try? await viewModel.addBeeYard()
                }
            } label: {
                Text("Add bee yards. current: \(viewModel.dbUser?.yardsCount?.description ?? "no yards")")
            }
        }
        .onAppear {
            Task {
                try? await viewModel.loadCurrentUser()
            }
        }
    }
}

#Preview {
    TestView1()
        .environmentObject(
            TestViewModel(userService: UserService(), authService: AuthenticationService())
        )
}
