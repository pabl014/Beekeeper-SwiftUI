//
//  TabBarView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 24/04/2025.
//

import SwiftUI

struct TabBarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                //TestView1()
                TestHomeView()
            }
            .tabItem {
                Image(systemName: "house.lodge.fill")
                Text("Bee hives")
            }
            
            
            NavigationStack {
                //ToDoView()
                TaskView()
            }
            .tabItem {
                Image(systemName: "list.star")
                Text("Tasks")
            }
            
            NavigationStack {
                TestExpenseView()
                //ExpensesView()
            }
            .tabItem {
                Image(systemName: "dollarsign")
                Text("Finances")
            }
            
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
        .tint(.orange)
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
        .environmentObject( AuthenticationViewModel(
                                authService: AuthenticationService()
                            )
        )
        .environmentObject(
            TestViewModel(userService: UserService(), authService: AuthenticationService())
        )
}
