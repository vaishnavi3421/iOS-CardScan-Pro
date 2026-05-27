//
//  AuthRepository.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let keychainManager: KeychainManagerProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        keychainManager: KeychainManagerProtocol = KeychainManager()
    ) {
        self.networkService = networkService
        self.keychainManager = keychainManager
    }
    
    func login(email: String, password: String) async throws -> User {
        let requestDTO = LoginRequestDTO(email: email, password: password)
        guard let requestBody = try? JSONEncoder().encode(requestDTO) else {
            throw NetworkError.unknown
        }
        
        let responseDTO: LoginResponseDTO = try await networkService.request(.login, body: requestBody)
        return responseDTO.toDomain()
    }
    
    func getCurrentUser() async -> User? {
        guard let token = keychainManager.loadString(key: AppConstants.Keychain.tokenKey),
              let userId = keychainManager.loadString(key: AppConstants.Keychain.userIdKey),
              let employeeId = keychainManager.loadString(key: AppConstants.Keychain.employeeIdKey) else {
            return nil
        }
        
        // Return cached user session
        return User(
            id: userId,
            employeeId: employeeId,
            name: "Corporate User", // Or load custom saved user profile
            email: "",
            token: token
        )
    }
    
    func saveSession(user: User) throws {
        let successToken = keychainManager.saveString(key: AppConstants.Keychain.tokenKey, value: user.token)
        let successUserId = keychainManager.saveString(key: AppConstants.Keychain.userIdKey, value: user.id)
        let successEmployeeId = keychainManager.saveString(key: AppConstants.Keychain.employeeIdKey, value: user.employeeId)
        
        guard successToken && successUserId && successEmployeeId else {
            throw NSError(domain: "AuthRepositoryError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to write user credentials to Keychain securely."])
        }
    }
    
    func logout() throws {
        let success = keychainManager.clearAll()
        guard success else {
            throw NSError(domain: "AuthRepositoryError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to securely wipe Keychain credentials during logout."])
        }
    }
}
