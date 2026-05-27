//
//  NetworkServiceTests.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

#if canImport(XCTest)
import XCTest
@testable import ScanCardPro

final class NetworkServiceTests: XCTestCase {
    
    private var sut: NetworkService!
    private var session: URLSession!
    private var keychainMock: KeychainMock!
    private var monitorMock: NetworkMonitorMock!
    
    override func setUp() {
        super.setUp()
        
        // Configure URLSession to use our MockURLProtocol interceptor
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        
        keychainMock = KeychainMock()
        monitorMock = NetworkMonitorMock()
        monitorMock.isConnected = true
        
        sut = NetworkService(
            session: session,
            keychainManager: keychainMock,
            networkMonitor: monitorMock
        )
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        keychainMock = nil
        monitorMock = nil
        super.tearDown()
    }
    
    func test_request_successfulDecoding() async throws {
        // Given
        let expectedUser = User(id: "123", employeeId: "EMP01", name: "Alice", email: "alice@corporate.com", token: "jwt_token")
        let jsonDTO = """
        {
            "id": "123",
            "employeeId": "EMP01",
            "name": "Alice",
            "email": "alice@corporate.com",
            "token": "jwt_token"
        }
        """
        let data = jsonDTO.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        let returnedUser: LoginResponseDTO = try await sut.request(.login)
        
        // Then
        XCTAssertEqual(returnedUser.id, expectedUser.id)
        XCTAssertEqual(returnedUser.employeeId, expectedUser.employeeId)
        XCTAssertEqual(returnedUser.name, expectedUser.name)
    }
    
    func test_request_unauthorizedError() async {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        // When/Then
        do {
            let _: LoginResponseDTO = try await sut.request(.login)
            XCTFail("Should have thrown an unauthorized error, but completed successfully.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}

// MARK: - Mocks for Testing

private final class KeychainMock: KeychainManagerProtocol {
    private var dict: [String: String] = [:]
    
    func save(key: String, data: Data) -> Bool { return true }
    func load(key: String) -> Data? { return nil }
    func delete(key: String) -> Bool { return true }
    func clearAll() -> Bool { return true }
    
    func saveString(key: String, value: String) -> Bool {
        dict[key] = value
        return true
    }
    
    func loadString(key: String) -> String? {
        return dict[key]
    }
}

private final class NetworkMonitorMock: NetworkMonitorProtocol {
    var isConnected: Bool = false
    var connectionType: NetworkMonitor.ConnectionType = .wifi
    var pathUpdateHandler: ((Bool) -> Void)?
    
    func startMonitoring() {}
    func stopMonitoring() {}
}
#endif
