//
//  ScanCardViewModel.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class ScanCardViewModel: BaseViewModel {
    
    private let scanCardUseCase: ScanCardUseCase
    private let uploadCardUseCase: UploadCardUseCase
    private let user: User
    private weak var coordinator: MainCoordinator?
    
    // Binding closures
    var onParsingComplete: ((VisitingCard) -> Void)?
    
    init(
        scanCardUseCase: ScanCardUseCase,
        uploadCardUseCase: UploadCardUseCase,
        user: User,
        coordinator: MainCoordinator
    ) {
        self.scanCardUseCase = scanCardUseCase
        self.uploadCardUseCase = uploadCardUseCase
        self.user = user
        self.coordinator = coordinator
        super.init()
    }
    
    @MainActor
    func processCapturedImage(data: Data) {
        state = .loading
        
        Task {
            do {
                // 1. Upload to OCR Parsing service
                var parsedCard = try await scanCardUseCase.execute(imageData: data)
                
                // Set current employee association using new corporate properties
                parsedCard = VisitingCard(
                    visitingCardId: parsedCard.visitingCardId,
                    employeeCode: user.employeeId,
                    personName: parsedCard.personName,
                    branchName: parsedCard.branchName,
                    companyName: parsedCard.companyName,
                    phoneNumber: parsedCard.phoneNumber,
                    emailId: parsedCard.emailId,
                    address: parsedCard.address,
                    designation: parsedCard.designation,
                    webSiteURL: parsedCard.webSiteURL,
                    image: parsedCard.image,
                    createdBy: parsedCard.createdBy,
                    createdOn: parsedCard.createdOn,
                    isActive: parsedCard.isActive,
                    isActiveId: parsedCard.isActiveId
                )
                
                state = .idle
                onParsingComplete?(parsedCard)
                
                // 2. Direct user to Editable Preview Screen (which is the Edit screen)
                // When saved, we upload the card and pop back
                coordinator?.showEditCard(card: parsedCard) { [weak self] finalCard in
                    guard let self = self else { return }
                    self.uploadVisitingCard(finalCard)
                }
            } catch {
                state = .error(error.localizedDescription)
                errorMessage = "OCR Parsing Failed: " + error.localizedDescription
            }
        }
    }
    
    @MainActor
    private func uploadVisitingCard(_ card: VisitingCard) {
        state = .loading
        Task {
            do {
                try await uploadCardUseCase.execute(card: card)
                state = .idle
                // Go back to dashboard / main flow
                coordinator?.popViewController()
            } catch {
                state = .error(error.localizedDescription)
                errorMessage = "Upload Failed: " + error.localizedDescription
            }
        }
    }
}
