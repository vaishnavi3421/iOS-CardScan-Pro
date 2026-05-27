//
//  NetworkService.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func request<T: Decodable>(_ endpoint: APIEndpoint, body: Data?) async throws -> T
    func requestMultipart<T: Decodable>(_ endpoint: APIEndpoint, multipartData: Data, boundary: String) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let keychainManager: KeychainManagerProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private let jsonDecoder: JSONDecoder
    
    init(
        session: URLSession = .shared,
        keychainManager: KeychainManagerProtocol = KeychainManager(),
        networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared
    ) {
        self.session = session
        self.keychainManager = keychainManager
        self.networkMonitor = networkMonitor
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.jsonDecoder = decoder
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, body: Data? = nil) async throws -> T {
        // 1. Check Network Connectivity
        guard networkMonitor.isConnected else {
            throw NetworkError.noNetwork
        }
        
        // 2. Fetch Bearer Token from Keychain if available
        let token = keychainManager.loadString(key: AppConstants.Keychain.tokenKey)
        
        // 3. Make URLRequest
        var urlRequest = try endpoint.makeURLRequest(token: token)
        urlRequest.httpBody = body
        
        // 4. Perform Data Task
        let (data, response) = try await session.data(for: urlRequest)
        
        // 5. Handle Status Codes
        try handleHTTPResponse(response)
        
        // 6. Decode JSON Response
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }
    
    func requestMultipart<T: Decodable>(_ endpoint: APIEndpoint, multipartData: Data, boundary: String) async throws -> T {
        guard networkMonitor.isConnected else {
            throw NetworkError.noNetwork
        }
        
        let token = keychainManager.loadString(key: AppConstants.Keychain.tokenKey)
        
        // Build the base request (APIEndpoint handles injecting header Content-Type boundary)
        var urlRequest = try endpoint.makeURLRequest(token: token)
        urlRequest.httpBody = multipartData
        
        let (data, response) = try await session.data(for: urlRequest)
        
        try handleHTTPResponse(response)
        
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    private func handleHTTPResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return // Request was successful
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}
