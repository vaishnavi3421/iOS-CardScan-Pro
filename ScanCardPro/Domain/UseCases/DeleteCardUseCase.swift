//
//  DeleteCardUseCase.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class DeleteCardUseCase {
    private let repository: VisitingCardRepository
    
    init(repository: VisitingCardRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async throws {
        guard !id.isEmpty, let intId = Int(id) else {
            throw NSError(domain: "DeleteCardUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Visiting card ID must be a valid integer."])
        }
        try await repository.deleteVisitingCard(id: intId)
    }
}
