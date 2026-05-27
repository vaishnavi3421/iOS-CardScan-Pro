//
//  VisitingCardViewModel.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class VisitingCardViewModel {
    
    // MARK: - State Types
    
    enum State: Equatable {
        case idle
        case loading
        case empty
        case loaded
        case error(String)
    }
    
    // MARK: - Properties
    
    private let repository: VisitingCardRepository
    
    private(set) var cards: [VisitingCard] = []
    private(set) var filteredCards: [VisitingCard] = []
    
    /// Track selected card IDs for multi-card sharing operations.
    var selectedCards = Set<Int>()
    
    var searchQuery = "" {
        didSet {
            applySearchAndFilter()
        }
    }
    
    // MARK: - Bindings
    
    var onStateChange: ((State) -> Void)?
    var onErrorMessage: ((String) -> Void)?
    var onSuccessMessage: ((String) -> Void)?
    var onCardsLoaded: (() -> Void)?
    var onNavRoute: ((Route) -> Void)?
    
    enum Route {
        case addEdit(VisitingCard?)
    }
    
    private(set) var state: State = .idle {
        didSet {
            onStateChange?(state)
        }
    }
    
    // MARK: - Initializer
    
    init(repository: VisitingCardRepository = VisitingCardRepositoryImpl()) {
        self.repository = repository
    }
    
    // MARK: - Business Flows
    
    @MainActor
    func fetchVisitingCards(employeeId: String) {
        state = .loading
        
        Task {
            do {
                let fetchedCards = try await repository.fetchVisitingCards(employeeId: employeeId)
                self.cards = fetchedCards
                self.applySearchAndFilter()
                
                self.state = self.filteredCards.isEmpty ? .empty : .loaded
            } catch {
                self.state = .error(error.localizedDescription)
                self.onErrorMessage?(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func createVisitingCard(card: VisitingCard) {
        state = .loading
        
        Task {
            do {
                try await repository.createVisitingCard(card: card)
                state = .idle
                onSuccessMessage?("Visiting Card details saved successfully!")
                
                // Automatically reload list
                fetchVisitingCards(employeeId: card.employeeCode)
            } catch {
                state = .idle
                onErrorMessage?(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func updateVisitingCard(card: VisitingCard) {
        state = .loading
        
        Task {
            do {
                try await repository.updateVisitingCard(card: card)
                state = .idle
                onSuccessMessage?("Visiting Card updated successfully!")
                
                // Reload list
                fetchVisitingCards(employeeId: card.employeeCode)
            } catch {
                state = .idle
                onErrorMessage?(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func deleteVisitingCard(id: Int, employeeCode: String) {
        state = .loading
        
        Task {
            do {
                try await repository.deleteVisitingCard(id: id)
                state = .idle
                onSuccessMessage?("Visiting Card details deleted successfully!")
                
                // Remove locally to avoid full API reload hit
                cards.removeAll { $0.visitingCardId == id }
                applySearchAndFilter()
                
                state = filteredCards.isEmpty ? .empty : .loaded
            } catch {
                state = .idle
                onErrorMessage?(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func shareVisitingCards(employeeCode: String, creator: String) {
        let selectedIds = Array(selectedCards)
        guard !selectedIds.isEmpty else {
            onErrorMessage?("Please select at least one card to share.")
            return
        }
        
        state = .loading
        
        Task {
            do {
                try await repository.shareVisitingCards(ids: selectedIds, employeeCode: employeeCode, creator: creator)
                selectedCards.removeAll() // Clear selection after successful share
                state = .idle
                onSuccessMessage?("Visiting Card Shared Successfully!")
            } catch {
                state = .idle
                onErrorMessage?(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func updateCardStatus(employeeCode: String, status: Int) {
        state = .loading
        
        Task {
            do {
                try await repository.updateCardStatus(employeeCode: employeeCode, status: status)
                state = .idle
                onSuccessMessage?("Card status updated successfully!")
            } catch {
                state = .idle
                onErrorMessage?(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Selection Management
    
    func toggleSelection(for cardId: Int) {
        if selectedCards.contains(cardId) {
            selectedCards.remove(cardId)
        } else {
            selectedCards.insert(cardId)
        }
        onCardsLoaded?()
    }
    
    func clearSelection() {
        selectedCards.removeAll()
        onCardsLoaded?()
    }
    
    // MARK: - Private Helpers
    
    private func applySearchAndFilter() {
        if searchQuery.isEmpty {
            filteredCards = cards
        } else {
            let query = searchQuery.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            filteredCards = cards.filter { card in
                card.personName.lowercased().contains(query) ||
                card.companyName.lowercased().contains(query) ||
                card.designation.lowercased().contains(query) ||
                card.emailId.lowercased().contains(query) ||
                card.phoneNumber.contains(query)
            }
        }
        onCardsLoaded?()
    }
}
