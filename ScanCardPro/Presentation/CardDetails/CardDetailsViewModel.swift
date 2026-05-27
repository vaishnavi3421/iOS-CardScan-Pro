//
//  CardDetailsViewModel.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class CardDetailsViewModel: BaseViewModel {
    
    private(set) var card: VisitingCard
    private let deleteCardUseCase: DeleteCardUseCase
    private weak var coordinator: MainCoordinator?
    
    // Binding closures
    var onCardReloaded: (() -> Void)?
    
    init(
        card: VisitingCard,
        deleteCardUseCase: DeleteCardUseCase,
        coordinator: MainCoordinator
    ) {
        self.card = card
        self.deleteCardUseCase = deleteCardUseCase
        self.coordinator = coordinator
        super.init()
    }
    
    func editCard() {
        coordinator?.showEditCard(card: card) { [weak self] updatedCard in
            guard let self = self else { return }
            self.card = updatedCard
            self.onCardReloaded?()
        }
    }
    
    @MainActor
    func deleteCard() {
        state = .loading
        Task {
            do {
                try await deleteCardUseCase.execute(id: card.id)
                state = .idle
                coordinator?.popViewController()
            } catch {
                state = .error(error.localizedDescription)
                errorMessage = "Delete Failed: " + error.localizedDescription
            }
        }
    }
}
