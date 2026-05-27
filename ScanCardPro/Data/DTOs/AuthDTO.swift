//
//  AuthDTO.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

struct LoginRequestDTO: Codable {
    let email: String
    let password: String
}

struct LoginResponseDTO: Codable {
    let id: String
    let employeeId: String
    let name: String
    let email: String
    let token: String
    
    func toDomain() -> User {
        return User(
            id: id,
            employeeId: employeeId,
            name: name,
            email: email,
            token: token
        )
    }
}
