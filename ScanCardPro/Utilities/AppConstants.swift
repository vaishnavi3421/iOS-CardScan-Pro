//
//  AppConstants.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

struct AppConstants {
    
    // MARK: - API Configurations
    struct API {
        static let baseURL = "https://api.cardscanpro.com" // Update as per environment configurations
        static let timeoutInterval: TimeInterval = 30.0
    }
    
    // MARK: - Keychain Keys
    struct Keychain {
        static let serviceIdentifier = "com.cardscanpro.keychain"
        static let tokenKey = "user_access_token"
        static let userIdKey = "logged_in_user_id"
        static let employeeIdKey = "user_employee_id"
    }
    
    // MARK: - Core Data
    struct CoreData {
        static let modelName = "ScanCardPro"
        static let visitingCardEntityName = "VisitingCardEntity"
    }
    
    // MARK: - UI Theme
    struct Style {
        static let primaryColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0)     // Modern premium cobalt blue
        static let secondaryColor = UIColor(red: 79/255, green: 70/255, blue: 229/255, alpha: 1.0)   // Deep indigo
        static let accentColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0)     // Premium warm amber
        static let successColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)    // Emerald green
        static let errorColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0)       // Vivid red
        static let backgroundColor = UIColor.systemGroupedBackground
        static let cardBackgroundColor = UIColor.secondarySystemGroupedBackground
        
        static let cornerRadius: CGFloat = 12.0
        static let shadowOpacity: Float = 0.08
        static let shadowRadius: CGFloat = 8.0
        static let shadowOffset = CGSize(width: 0, height: 4)
    }
}
