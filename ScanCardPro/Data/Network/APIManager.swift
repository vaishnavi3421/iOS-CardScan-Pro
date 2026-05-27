//
//  APIManager.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

protocol APIManagerProtocol: AnyObject {
    func execute<T: Codable>(_ endpoint: APIEndpoint) async throws -> T
}

final class APIManager: APIManagerProtocol {
    
    static let shared = APIManager()
    
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(session: URLSession? = nil) {
        if let customSession = session {
            self.session = customSession
        } else {
            self.session = URLSession(
                configuration: .default,
                delegate: SSLBypassSessionDelegate(),
                delegateQueue: nil
            )
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Handles standard timestamp layouts
        self.jsonDecoder = decoder
    }
    
    func execute<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
        // 1. Build request
        let request = try endpoint.makeURLRequest()
        
        // 2. Perform network data task
        let (data, response) = try await session.data(for: request)
        
        // 3. Verify status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        // 4. Parse payload as BaseResponse<T> to extract generic parameters
        do {
            let parsedResponse = try jsonDecoder.decode(BaseResponse<T>.self, from: data)
            
            if parsedResponse.isSuccess {
                // Some successful operations return empty data structures (e.g. Save, Share, Delete endpoints)
                if let payload = parsedResponse.data {
                    return payload
                } else if T.self == EmptyData.self {
                    return EmptyData() as! T
                } else {
                    throw NetworkError.decodingFailed("Server returned success but data payload is empty.")
                }
            } else {
                throw NetworkError.apiError(message: parsedResponse.message)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }
}

// MARK: - SSL Bypass Delegate

final class SSLBypassSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
