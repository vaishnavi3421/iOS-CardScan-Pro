//
//  GetVisitingCardsUseCase.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class GetVisitingCardsUseCase {
    private let repository: VisitingCardRepository
    
    init(repository: VisitingCardRepository) {
        self.repository = repository
    }
    
    func execute(employeeId: String, forceRefresh: Bool = false) async throws -> [VisitingCard] {
        guard !employeeId.isEmpty else {
            throw NSError(domain: "GetVisitingCardsUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Employee ID cannot be empty."])
        }
        return try await repository.fetchVisitingCards(employeeId: employeeId)
    }
}
