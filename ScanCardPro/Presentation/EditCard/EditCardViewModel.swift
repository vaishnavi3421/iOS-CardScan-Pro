//
//  EditCardViewModel.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class EditCardViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    private(set) var card: VisitingCard
    private let updateCardUseCase: UpdateCardUseCase
    private weak var coordinator: MainCoordinator?
    private let onSave: (VisitingCard) -> Void
    
    // MARK: - Initializer
    
    init(
        card: VisitingCard,
        updateCardUseCase: UpdateCardUseCase,
        coordinator: MainCoordinator,
        onSave: @escaping (VisitingCard) -> Void
    ) {
        self.card = card
        self.updateCardUseCase = updateCardUseCase
        self.coordinator = coordinator
        self.onSave = onSave
        super.init()
    }
    
    // MARK: - Operations
    
    @MainActor
    func saveCard(
        personName: String,
        designation: String,
        companyName: String,
        phoneNumber: String,
        emailId: String,
        branchName: String,
        address: String,
        webSiteURL: String
    ) {
        // Validate inputs before starting the async task
        guard !personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Contact Name is required."
            return
        }
        guard !designation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Designation is required."
            return
        }
        guard !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Phone Number is required."
            return
        }
        if !emailId.isEmpty && !emailId.contains("@") {
            errorMessage = "Invalid email format."
            return
        }
        
        state = .loading
        
        let updatedCard = VisitingCard(
            visitingCardId: card.visitingCardId,
            employeeCode: card.employeeCode,
            personName: personName,
            branchName: branchName,
            companyName: companyName,
            phoneNumber: phoneNumber,
            emailId: emailId,
            address: address,
            designation: designation,
            webSiteURL: webSiteURL,
            image: card.image,
            createdBy: card.createdBy,
            createdOn: card.createdOn,
            isActive: card.isActive,
            isActiveId: card.isActiveId
        )
        
        Task {
            do {
                try await updateCardUseCase.execute(card: updatedCard)
                state = .idle
                onSave(updatedCard)
                coordinator?.popViewController()
            } catch {
                state = .idle
                errorMessage = error.localizedDescription
            }
        }
    }
}
