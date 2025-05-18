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
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authViewModel = AuthenticationViewModel(authService: AuthenticationService(), userService: UserService())
    @StateObject var testViewModel = TestViewModel(userService: UserService(), authService: AuthenticationService())
    @StateObject var tasksViewModel = TasksViewModel(authService: AuthenticationService(), tasksService: TasksService())
    @StateObject var transactionsViewModel = TransactionsViewModel(authService: AuthenticationService(), transactionsService: TransactionsService())
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(testViewModel)
                .environmentObject(tasksViewModel)
                .environmentObject(transactionsViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Configured Firebase!")
        return true
    }
}
