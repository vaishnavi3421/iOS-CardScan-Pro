//
//  VisitingCardRepository.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

/// Defines all business operations related to corporate visiting cards.
protocol VisitingCardRepository: AnyObject {
    func fetchVisitingCards(employeeId: String) async throws -> [VisitingCard]
    func createVisitingCard(card: VisitingCard) async throws
    func updateVisitingCard(card: VisitingCard) async throws
    func deleteVisitingCard(id: Int) async throws
    func shareVisitingCards(ids: [Int], employeeCode: String, creator: String) async throws
    func updateCardStatus(employeeCode: String, status: Int) async throws
}
