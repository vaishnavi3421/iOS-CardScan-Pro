//
//  MultipartUploadManager.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

struct MultipartUploadManager {
    
    /// Creates a standard multipart/form-data body payload.
    /// - Parameters:
    ///   - parameters: Text fields key-value dictionary.
    ///   - fileData: Raw binary data of the file.
    ///   - fileName: The name of the file to attach.
    ///   - mimeType: The type of attachment (e.g. image/jpeg, image/png).
    ///   - fileKey: The API key for the file payload (e.g., "file", "image").
    ///   - boundary: The randomly generated boundary string.
    /// - Returns: A binary Data stream.
    static func buildBody(
        parameters: [String: String],
        fileData: Data?,
        fileName: String,
        mimeType: String,
        fileKey: String,
        boundary: String
    ) -> Data {
        var body = Data()
        
        let lineBreak = "\r\n"
        
        // Append text fields
        for (key, value) in parameters {
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)")
            body.append("\(value)\(lineBreak)")
        }
        
        // Append binary file if present
        if let data = fileData {
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(fileName)\"\(lineBreak)")
            body.append("Content-Type: \(mimeType)\(lineBreak)\(lineBreak)")
            body.append(data)
            body.append(lineBreak)
        }
        
        // End marker boundary
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

// Helper extension to make appending strings to Data objects clean
private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
