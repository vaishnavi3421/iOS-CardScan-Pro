//
//  AuthRepositoryProtocol.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

protocol AuthRepositoryProtocol: AnyObject {
    func login(email: String, password: String) async throws -> User
    func getCurrentUser() async -> User?
    func saveSession(user: User) throws
    func logout() throws
}
