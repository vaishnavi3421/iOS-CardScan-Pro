//
//  MainCoordinator.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencyContainer: AppDependencyContainer
    private let user: User
    private weak var parentCoordinator: AppCoordinator?
    
    init(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer,
        user: User,
        parentCoordinator: AppCoordinator
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
        self.user = user
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let homeVM = HomeViewModel(
            user: user,
            getCardsUseCase: dependencyContainer.makeGetVisitingCardsUseCase(),
            coordinator: self
        )
        let homeVC = HomeViewController(viewModel: homeVM)
        navigationController.setViewControllers([homeVC], animated: true)
    }
    
    func showScanCard() {
        let scanVM = ScanCardViewModel(
            scanCardUseCase: dependencyContainer.makeScanCardUseCase(),
            uploadCardUseCase: dependencyContainer.makeUploadCardUseCase(),
            user: user,
            coordinator: self
        )
        let scanVC = ScanCardViewController(viewModel: scanVM)
        navigationController.pushViewController(scanVC, animated: true)
    }
    
    func showCardList() {
        let repo = VisitingCardRepositoryImpl()
        let viewModel = VisitingCardViewModel(repository: repo)
        let listVC = VisitingCardListViewController(viewModel: viewModel)
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func showCardDetails(card: VisitingCard) {
        // Updated to use the new corporate VisitingCard struct
        let detailsVM = CardDetailsViewModel(
            card: card,
            deleteCardUseCase: dependencyContainer.makeDeleteCardUseCase(),
            coordinator: self
        )
        let detailsVC = CardDetailsViewController(viewModel: detailsVM)
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func showEditCard(card: VisitingCard, onSave: @escaping (VisitingCard) -> Void) {
        let editVM = EditCardViewModel(
            card: card,
            updateCardUseCase: dependencyContainer.makeUpdateCardUseCase(),
            coordinator: self,
            onSave: onSave
        )
        let editVC = EditCardViewController(viewModel: editVM)
        navigationController.pushViewController(editVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func logout() {
        do {
            try dependencyContainer.makeAuthUseCase().executeLogout()
            parentCoordinator?.showAuthFlow()
        } catch {
            print("Failed to logout securely: \(error.localizedDescription)")
        }
    }
}
