//
//  VisitingCard.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

enum VisitingCardSyncStatus: String, Codable, CaseIterable {
    case synced
    case pendingUpload
    case pendingUpdate
    case pendingDelete
}

/// The pure domain-level entity representing a corporate visiting card.
struct VisitingCard: Identifiable, Hashable, Equatable {
    
    var id: String {
        return String(visitingCardId)
    }
    
    let visitingCardId: Int
    let employeeCode: String
    let personName: String
    let branchName: String
    let companyName: String
    let phoneNumber: String
    let emailId: String
    let address: String
    let designation: String
    let webSiteURL: String
    let image: String
    let createdBy: String
    let createdOn: Date
    let isActive: String
    let isActiveId: Int
    
    var syncStatus: VisitingCardSyncStatus = .synced
}
