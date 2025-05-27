//
//  DIContainer.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 28/05/2025.
//

import Foundation

final class DIContainer {
    
    let authService: AuthenticationService
    let userService: UserService
    let tasksService: TasksService
    let transactionsService: TransactionsService
    let hivesService: HivesService

    init() {
        self.authService = AuthenticationService()
        self.userService = UserService()
        self.tasksService = TasksService()
        self.transactionsService = TransactionsService()
        self.hivesService = HivesService()
    }
    
    @MainActor
    func makeAuthViewModel() -> AuthenticationViewModel {
        AuthenticationViewModel(authService: authService, userService: userService)
    }
    
    @MainActor
    func makeTasksViewModel() -> TasksViewModel {
        TasksViewModel(authService: authService, tasksService: tasksService)
    }
    
    @MainActor
    func makeTransactionsViewModel() -> TransactionsViewModel {
        TransactionsViewModel(authService: authService, transactionsService: transactionsService)
    }
    
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(authService: authService, hivesService: hivesService)
    }
}
