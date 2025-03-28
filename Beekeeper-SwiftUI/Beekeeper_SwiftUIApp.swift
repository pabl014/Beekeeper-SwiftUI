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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
