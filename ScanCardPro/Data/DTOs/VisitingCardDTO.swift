//
//  VisitingCardDTO.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

// MARK: - Response DTO
struct VisitingCardDTO: Codable {
    let visitingCardId: Int
    let employeeCode: String
    let personName: String
    let branchName: String?
    let companyName: String?
    let phoneNumber: String
    let emailId: String
    let address: String?
    let designation: String
    let webSiteURL: String?
    let image: String?
    let createdBy: String?
    let createdOn: String?
    let isActive: String?
    let isActiveId: Int?
    
    enum CodingKeys: String, CodingKey {
        case visitingCardId = "VisitingCardId"
        case employeeCode = "EmployeeCode"
        case personName = "PersonName"
        case branchName = "BranchName"
        case companyName = "CompanyName"
        case phoneNumber = "PhoneNumber"
        case emailId = "EmailId"
        case address = "Address"
        case designation = "Designation"
        case webSiteURL = "WebSiteURL"
        case image = "Image"
        case createdBy = "CreatedBy"
        case createdOn = "CreatedOn"
        case isActive = "IsActive"
        case isActiveId
    }
    
    /// Maps response payload to pure Domain VisitingCard.
    func toDomain() -> VisitingCard {
        let formatter = ISO8601DateFormatter()
        // Support either standard ISO8601 dates or basic timestamps
        let parsedDate: Date
        if let createdStr = createdOn {
            if let date = formatter.date(from: createdStr) {
                parsedDate = date
            } else {
                let fallbackFormatter = DateFormatter()
                fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                parsedDate = fallbackFormatter.date(from: createdStr) ?? Date()
            }
        } else {
            parsedDate = Date()
        }
        
        return VisitingCard(
            visitingCardId: visitingCardId,
            employeeCode: employeeCode,
            personName: personName,
            branchName: branchName ?? "",
            companyName: companyName ?? "",
            phoneNumber: phoneNumber,
            emailId: emailId,
            address: address ?? "",
            designation: designation,
            webSiteURL: webSiteURL ?? "",
            image: image ?? "",
            createdBy: createdBy ?? "sys",
            createdOn: parsedDate,
            isActive: isActive ?? "Active",
            isActiveId: isActiveId ?? 1
        )
    }
}

// MARK: - Issue/Upload & Update Request DTO
struct VisitingCardRequestDTO: Codable {
    let visitingCardId: Int
    let employeeCode: String
    let personName: String
    let companyName: String
    let phoneNumber: String
    let emailId: String
    let address: String
    let designation: String
    let webSiteURL: String
    let image: String
    let createdBy: String
    let isActiveId: Int
}

// MARK: - Share Shared Card Request DTO
struct ShareCardRequestDTO: Codable {
    let visitingCardId: [Int]
    let employeeCode: String
    let createdBy: String
    let isActiveId: Int
}

// MARK: - Update Status Request DTO
struct UpdateStatusRequestDTO: Codable {
    let employeeCode: String
    let status: Int
}
