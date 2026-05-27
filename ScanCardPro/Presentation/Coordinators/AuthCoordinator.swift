//
//  AuthCoordinator.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencyContainer: AppDependencyContainer
    private weak var parentCoordinator: AppCoordinator?
    
    init(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer,
        parentCoordinator: AppCoordinator
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let loginVM = LoginViewModel(
            authUseCase: dependencyContainer.makeAuthUseCase(),
            coordinator: self
        )
        let loginVC = LoginViewController(viewModel: loginVM)
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func didLoginSuccessfully(user: User) {
        Task { @MainActor in
            parentCoordinator?.showMainFlow(for: user)
        }
    }
}
