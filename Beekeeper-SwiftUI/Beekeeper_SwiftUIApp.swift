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
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        print("Configured Firebase!")
//        return true
//    }
//}
