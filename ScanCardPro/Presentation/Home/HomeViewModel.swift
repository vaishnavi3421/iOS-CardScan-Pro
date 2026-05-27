//
//  HomeViewModel.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class HomeViewModel: BaseViewModel {
    
    private let user: User
    private let getCardsUseCase: GetVisitingCardsUseCase
    private weak var coordinator: MainCoordinator?
    
    // Bindings
    var onMetricsUpdated: ((DashboardMetrics) -> Void)?
    
    var employeeName: String {
        return user.name
    }
    
    var employeeId: String {
        return user.employeeId
    }
    
    struct DashboardMetrics {
        let totalCount: Int
        let syncedCount: Int
        let pendingCount: Int
    }
    
    init(
        user: User,
        getCardsUseCase: GetVisitingCardsUseCase,
        coordinator: MainCoordinator
    ) {
        self.user = user
        self.getCardsUseCase = getCardsUseCase
        self.coordinator = coordinator
        super.init()
    }
    
    @MainActor
    func loadDashboardData() {
        state = .loading
        Task {
            do {
                // Fetch local cards to build dashboard metrics instantly (SSOT)
                let cards = try await getCardsUseCase.execute(employeeId: user.employeeId, forceRefresh: false)
                
                let total = cards.count
                let synced = cards.filter { $0.syncStatus == .synced }.count
                let pending = cards.filter { $0.syncStatus == .pendingUpload || $0.syncStatus == .pendingUpdate || $0.syncStatus == .pendingDelete }.count
                
                let metrics = DashboardMetrics(totalCount: total, syncedCount: synced, pendingCount: pending)
                onMetricsUpdated?(metrics)
                state = .idle
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func navigateToScanner() {
        coordinator?.showScanCard()
    }
    
    func navigateToCardList() {
        coordinator?.showCardList()
    }
    
    func performLogout() {
        coordinator?.logout()
    }
}
