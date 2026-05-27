//
//  AuthUseCase.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class AuthUseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func executeLogin(email: String, password: String) async throws -> User {
        guard email == "34562", password == "HELLO69848" else {
            throw NSError(domain: "AuthUseCaseError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials. Please use Employee ID '34562' and password 'HELLO69848'."])
        }
        
        let user = User(
            id: "34562",
            employeeId: "34562",
            name: "Corporate User",
            email: "34562",
            token: "mock_jwt_token_for_34562"
        )
        try repository.saveSession(user: user)
        return user
    }
    
    func getCurrentUser() async -> User? {
        return await repository.getCurrentUser()
    }
    
    func executeLogout() throws {
        try repository.logout()
    }
}
