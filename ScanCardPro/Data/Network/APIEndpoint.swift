//
//  APIEndpoint.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIEndpoint {
    case login
    case listScannedCard(employeeId: String)
    case uploadNewVisitingCard(dto: VisitingCardRequestDTO)
    case shareVisitingCard(dto: ShareCardRequestDTO)
    case updateVisitingCardStatus(dto: UpdateStatusRequestDTO)
    case updateExistingVisitingCard(id: Int, dto: VisitingCardRequestDTO)
    case deleteVisitingCard(id: Int)
    
    private var baseURL: String {
        return "https://zentcorp.myhello.in"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/Auth/Login"
        case .listScannedCard(let employeeId):
            let resolvedId = employeeId.isEmpty ? "34562" : employeeId
            return "/api/CorporateVisitingCard/GetAllVisitingCardById/\(resolvedId)"
        case .uploadNewVisitingCard:
            return "/api/CorporateVisitingCard/IssueVisitingCard"
        case .shareVisitingCard:
            return "/api/CorporateVisitingCard/IssueVisitingSharedCard"
        case .updateVisitingCardStatus:
            return "/api/CorporateVisitingCard/UpdateVisitingCardStatus"
        case .updateExistingVisitingCard(let id, _):
            return "/api/CorporateVisitingCard/UpdateExistingVisitingCard/\(id)"
        case .deleteVisitingCard(let id):
            return "/api/CorporateVisitingCard/RemoveExistingVisitingCard/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listScannedCard:
            return .get
        case .login, .uploadNewVisitingCard, .shareVisitingCard, .updateVisitingCardStatus:
            return .post
        case .updateExistingVisitingCard:
            return .put
        case .deleteVisitingCard:
            return .delete
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .uploadNewVisitingCard(let dto), .updateExistingVisitingCard(_, let dto):
            return try? encoder.encode(dto)
        case .shareVisitingCard(let dto):
            return try? encoder.encode(dto)
        case .updateVisitingCardStatus(let dto):
            return try? encoder.encode(dto)
        default:
            return nil
        }
    }
    
    func makeURLRequest(token: String? = nil) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30.0
        
        // Headers setup
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Basic Auth credentials matching other application
        let credentials = "sa:Tenant@123"
        if let credentialData = credentials.data(using: .utf8) {
            let base64Credentials = credentialData.base64EncodedString()
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        }
        
        if let bodyData = body {
            request.httpBody = bodyData
        }
        
        return request
    }
}
