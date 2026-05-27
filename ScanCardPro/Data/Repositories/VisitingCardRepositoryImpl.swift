//
//  VisitingCardRepositoryImpl.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class VisitingCardRepositoryImpl: VisitingCardRepository {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func fetchVisitingCards(employeeId: String) async throws -> [VisitingCard] {
        let dtos: [VisitingCardDTO] = try await apiManager.execute(.listScannedCard(employeeId: employeeId))
        return dtos.map { $0.toDomain() }
    }
    
    func createVisitingCard(card: VisitingCard) async throws {
        let requestDTO = VisitingCardRequestDTO(
            visitingCardId: card.visitingCardId,
            employeeCode: card.employeeCode,
            personName: card.personName,
            companyName: card.companyName,
            phoneNumber: card.phoneNumber,
            emailId: card.emailId,
            address: card.address,
            designation: card.designation,
            webSiteURL: card.webSiteURL,
            image: card.image,
            createdBy: card.createdBy,
            isActiveId: card.isActiveId
        )
        
        let _: EmptyData = try await apiManager.execute(.uploadNewVisitingCard(dto: requestDTO))
    }
    
    func updateVisitingCard(card: VisitingCard) async throws {
        let requestDTO = VisitingCardRequestDTO(
            visitingCardId: card.visitingCardId,
            employeeCode: card.employeeCode,
            personName: card.personName,
            companyName: card.companyName,
            phoneNumber: card.phoneNumber,
            emailId: card.emailId,
            address: card.address,
            designation: card.designation,
            webSiteURL: card.webSiteURL,
            image: card.image,
            createdBy: card.createdBy,
            isActiveId: card.isActiveId
        )
        
        let _: EmptyData = try await apiManager.execute(.updateExistingVisitingCard(id: card.visitingCardId, dto: requestDTO))
    }
    
    func deleteVisitingCard(id: Int) async throws {
        let _: EmptyData = try await apiManager.execute(.deleteVisitingCard(id: id))
    }
    
    func shareVisitingCards(ids: [Int], employeeCode: String, creator: String) async throws {
        let requestDTO = ShareCardRequestDTO(
            visitingCardId: ids,
            employeeCode: employeeCode,
            createdBy: creator,
            isActiveId: 1 // Default active state identifier
        )
        
        let _: EmptyData = try await apiManager.execute(.shareVisitingCard(dto: requestDTO))
    }
    
    func updateCardStatus(employeeCode: String, status: Int) async throws {
        let requestDTO = UpdateStatusRequestDTO(
            employeeCode: employeeCode,
            status: status
        )
        
        let _: EmptyData = try await apiManager.execute(.updateVisitingCardStatus(dto: requestDTO))
    }
}
