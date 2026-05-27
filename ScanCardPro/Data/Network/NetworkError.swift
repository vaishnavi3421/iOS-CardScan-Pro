//
//  NetworkError.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

/// Defines all possible network and validation exceptions within the CardScan Pro network stack.
enum NetworkError: LocalizedError, Equatable {
    case badURL
    case invalidRequest
    case unauthorized
    case serverError(statusCode: Int)
    case apiError(message: String)
    case decodingFailed(String)
    case noNetwork
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The request URL is invalid. Please contact support."
        case .invalidRequest:
            return "Unable to construct request payload."
        case .unauthorized:
            return "Session expired. Please log in again."
        case .serverError(let code):
            return "The server responded with an error (Code: \(code))."
        case .apiError(let message):
            return message.isEmpty ? "An API error occurred." : message
        case .decodingFailed(let message):
            return "Failed to parse data payload: \(message)"
        case .noNetwork:
            return "No internet connection detected. Switch to offline cache."
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
}
