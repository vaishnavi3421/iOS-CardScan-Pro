//
//  AuthUseCaseTests.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

#if canImport(XCTest)
import XCTest
@testable import ScanCardPro

final class AuthUseCaseTests: XCTestCase {
    
    private var sut: AuthUseCase!
    private var repositoryMock: AuthRepositoryMock!
    
    override func setUp() {
        super.setUp()
        repositoryMock = AuthRepositoryMock()
        sut = AuthUseCase(repository: repositoryMock)
    }
    
    override func tearDown() {
        sut = nil
        repositoryMock = nil
        super.setUp()
    }
    
    func test_login_invalidCredentials_throwsError() async {
        // Given
        let email = "wrong_user"
        let password = "wrong_password"
        
        // When/Then
        do {
            let _ = try await sut.executeLogin(email: email, password: password)
            XCTFail("Should have failed for invalid credentials.")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "AuthUseCaseError")
            XCTAssertEqual(nsError.code, 401)
            XCTAssertTrue(nsError.localizedDescription.contains("Invalid credentials"))
        }
    }
    
    func test_login_validCredentials_completesSuccessfully() async throws {
        // Given
        let email = "34562"
        let password = "HELLO69848"
        
        // When
        let result = try await sut.executeLogin(email: email, password: password)
        
        // Then
        XCTAssertEqual(result.id, "34562")
        XCTAssertEqual(result.employeeId, "34562")
        XCTAssertTrue(repositoryMock.saveSessionCalled)
    }
}

// MARK: - Mocks for Testing

private final class AuthRepositoryMock: AuthRepositoryProtocol {
    
    var stubbedUser: User?
    var saveSessionCalled = false
    
    func login(email: String, password: String) async throws -> User {
        if let user = stubbedUser {
            return user
        }
        throw NSError(domain: "AuthRepositoryMock", code: 500, userInfo: nil)
    }
    
    func getCurrentUser() async -> User? {
        return stubbedUser
    }
    
    func saveSession(user: User) throws {
        saveSessionCalled = true
    }
    
    func logout() throws {
        // No-op
    }
}
#endif
