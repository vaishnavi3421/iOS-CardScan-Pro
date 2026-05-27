//
//  AppCoordinator.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencyContainer: AppDependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: AppDependencyContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        Task {
            // Check if there is an active session
            let authUseCase = dependencyContainer.makeAuthUseCase()
            if let user = await authUseCase.getCurrentUser() {
                print("AppCoordinator: Active user session found: \(user.employeeId). Directing to Dashboard.")
                await showMainFlow(for: user)
            } else {
                print("AppCoordinator: No active session. Directing to Login.")
                await showAuthFlow()
            }
        }
    }
    
    @MainActor
    func showAuthFlow() {
        // Clear children
        childCoordinators.removeAll()
        
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer,
            parentCoordinator: self
        )
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    @MainActor
    func showMainFlow(for user: User) {
        // Clear children
        childCoordinators.removeAll()
        
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer,
            user: user,
            parentCoordinator: self
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
