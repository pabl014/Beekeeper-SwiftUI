//
//  Beekeeper_SwiftUIApp.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/03/2025.
//

import SwiftUI
import FirebaseCore

@main
struct Beekeeper_SwiftUIApp: App {
    
    @StateObject var authViewModel: AuthenticationViewModel
    @StateObject var tasksViewModel: TasksViewModel
    @StateObject var transactionsViewModel: TransactionsViewModel
    @StateObject var homeViewModel: HomeViewModel

    init() {
        
        FirebaseApp.configure()
        
        let container = DIContainer()
        _authViewModel = StateObject(wrappedValue: container.makeAuthViewModel())
        _tasksViewModel = StateObject(wrappedValue: container.makeTasksViewModel())
        _transactionsViewModel = StateObject(wrappedValue: container.makeTransactionsViewModel())
        _homeViewModel = StateObject(wrappedValue: container.makeHomeViewModel())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(tasksViewModel)
                .environmentObject(transactionsViewModel)
                .environmentObject(homeViewModel)
        }
    }
}
