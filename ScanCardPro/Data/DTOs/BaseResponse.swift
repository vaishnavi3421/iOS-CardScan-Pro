//
//  BaseResponse.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

/// A generic response DTO wrapping standard corporate visiting card API payloads.
struct BaseResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let message: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "IsSuccess"
        case message = "Message"
        case data
    }
}

/// Helper DTO representing empty payloads in standard API responses.
struct EmptyData: Codable {}
