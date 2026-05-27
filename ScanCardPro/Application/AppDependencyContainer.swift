//
//  AppDependencyContainer.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class AppDependencyContainer {
    
    // MARK: - Singletons / Shared Dependencies
    
    private lazy var keychainManager: KeychainManagerProtocol = {
        return KeychainManager()
    }()
    
    private lazy var networkMonitor: NetworkMonitorProtocol = {
        let monitor = NetworkMonitor.shared
        monitor.startMonitoring() // Start listening immediately upon DI creation
        return monitor
    }()
    
    private lazy var networkService: NetworkServiceProtocol = {
        return NetworkService(
            session: .shared,
            keychainManager: keychainManager,
            networkMonitor: networkMonitor
        )
    }()
    
    private lazy var coreDataStack: CoreDataStackProtocol = {
        return CoreDataStack.shared
    }()
    
    // MARK: - Repositories
    
    private lazy var authRepository: AuthRepositoryProtocol = {
        return AuthRepository(
            networkService: networkService,
            keychainManager: keychainManager
        )
    }()
    
    private lazy var visitingCardRepository: VisitingCardRepository = {
        return VisitingCardRepositoryImpl(apiManager: APIManager.shared)
    }()
    
    // MARK: - Use Cases Factory Methods
    
    func makeAuthUseCase() -> AuthUseCase {
        return AuthUseCase(repository: authRepository)
    }
    
    func makeGetVisitingCardsUseCase() -> GetVisitingCardsUseCase {
        return GetVisitingCardsUseCase(repository: visitingCardRepository)
    }
    
    func makeScanCardUseCase() -> ScanCardUseCase {
        return ScanCardUseCase(repository: visitingCardRepository)
    }
    
    func makeUploadCardUseCase() -> UploadCardUseCase {
        return UploadCardUseCase(repository: visitingCardRepository)
    }
    
    func makeUpdateCardUseCase() -> UpdateCardUseCase {
        return UpdateCardUseCase(repository: visitingCardRepository)
    }
    
    func makeDeleteCardUseCase() -> DeleteCardUseCase {
        return DeleteCardUseCase(repository: visitingCardRepository)
    }
}
