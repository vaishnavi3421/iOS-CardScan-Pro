//
//  UploadCardUseCase.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class UploadCardUseCase {
    private let repository: VisitingCardRepository
    
    init(repository: VisitingCardRepository) {
        self.repository = repository
    }
    
    func execute(card: VisitingCard) async throws {
        // Domain Validation Rules
        guard !card.personName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(domain: "UploadCardUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Contact name cannot be empty."])
        }
        if !card.emailId.isEmpty && !card.emailId.contains("@") {
            throw NSError(domain: "UploadCardUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid email format."])
        }
        
        try await repository.createVisitingCard(card: card)
    }
}
