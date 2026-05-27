//
//  UpdateCardUseCase.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class UpdateCardUseCase {
    private let repository: VisitingCardRepository
    
    init(repository: VisitingCardRepository) {
        self.repository = repository
    }
    
    func execute(card: VisitingCard) async throws {
        guard card.visitingCardId > 0 else {
            throw NSError(domain: "UpdateCardUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Visiting card ID is missing."])
        }
        guard !card.personName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(domain: "UpdateCardUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Contact name cannot be empty."])
        }
        try await repository.updateVisitingCard(card: card)
    }
}
