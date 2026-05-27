//
//  VisitingCardEntity+Mapping.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation
import CoreData

@objc(VisitingCardEntity)
public class VisitingCardEntity: NSManagedObject {
    @NSManaged public var id: String?
    @NSManaged public var employeeId: String?
    @NSManaged public var name: String?
    @NSManaged public var companyName: String?
    @NSManaged public var designation: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var website: String?
    @NSManaged public var notes: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var syncStatus: String?
}

extension VisitingCardEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitingCardEntity> {
        return NSFetchRequest<VisitingCardEntity>(entityName: AppConstants.CoreData.visitingCardEntityName)
    }
    
    /// Converts a Core Data VisitingCardEntity to a pure Domain VisitingCard.
    func toDomain() -> VisitingCard {
        return VisitingCard(
            visitingCardId: Int(self.id ?? "") ?? 0,
            employeeCode: self.employeeId ?? "",
            personName: self.name ?? "",
            branchName: self.notes ?? "",
            companyName: self.companyName ?? "",
            phoneNumber: self.phone ?? "",
            emailId: self.email ?? "",
            address: self.website ?? "",
            designation: self.designation ?? "",
            webSiteURL: self.imagePath ?? "",
            image: self.imagePath ?? "",
            createdBy: "sys",
            createdOn: self.createdAt ?? Date(),
            isActive: "Active",
            isActiveId: 1,
            syncStatus: VisitingCardSyncStatus(rawValue: self.syncStatus ?? "") ?? .synced
        )
    }
    
    /// Configures the database entity with fields from a pure Domain VisitingCard.
    func update(from domain: VisitingCard) {
        self.id = String(domain.visitingCardId)
        self.employeeId = domain.employeeCode
        self.name = domain.personName
        self.companyName = domain.companyName
        self.designation = domain.designation
        self.email = domain.emailId
        self.phone = domain.phoneNumber
        self.website = domain.address
        self.notes = domain.branchName
        self.imagePath = domain.image
        self.createdAt = domain.createdOn
        self.updatedAt = Date()
        self.syncStatus = domain.syncStatus.rawValue
    }
}
