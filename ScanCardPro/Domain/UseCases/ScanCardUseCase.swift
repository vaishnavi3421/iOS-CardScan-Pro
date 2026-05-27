//
//  ScanCardUseCase.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class ScanCardUseCase {
    private let repository: VisitingCardRepository
    
    init(repository: VisitingCardRepository) {
        self.repository = repository
    }
    
    func execute(imageData: Data) async throws -> VisitingCard {
        guard !imageData.isEmpty else {
            throw NSError(domain: "ScanCardUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Scanned image data is empty."])
        }
        
        // Return a mock scanned card for compilation safety of the legacy camera module
        return VisitingCard(
            visitingCardId: Int.random(in: 1000...9999),
            employeeCode: "34562",
            personName: "Scanned Contact",
            branchName: "Corporate Office",
            companyName: "Extracted Company",
            phoneNumber: "+91 99999 99999",
            emailId: "contact@company.com",
            address: "Mumbai",
            designation: "Manager",
            webSiteURL: "www.company.com",
            image: "",
            createdBy: "sys",
            createdOn: Date(),
            isActive: "Active",
            isActiveId: 1
        )
    }
}
