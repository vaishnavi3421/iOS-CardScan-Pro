//
//  LoginViewModel.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

final class LoginViewModel: BaseViewModel {
    
    private let authUseCase: AuthUseCase
    private weak var coordinator: AuthCoordinator?
    
    // Core data bindings for login validation states
    var onValidationStateChange: ((Bool) -> Void)?
    
    var email = "" {
        didSet { validateInputs() }
    }
    var password = "" {
        didSet { validateInputs() }
    }
    
    var isEmailValid: Bool {
        // Standard email format validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isEmailFormat = emailPred.evaluate(with: email)
        
        // Employee ID format validation (e.g., 3 to 10 digits like 34562)
        let employeeIdRegEx = "^\\d{3,10}$"
        let employeeIdPred = NSPredicate(format:"SELF MATCHES %@", employeeIdRegEx)
        let isEmployeeIdFormat = employeeIdPred.evaluate(with: email)
        
        return isEmailFormat || isEmployeeIdFormat
    }
    
    var isPasswordValid: Bool {
        return password.count >= 6
    }
    
    private var isInputValid = false {
        didSet {
            onValidationStateChange?(isInputValid)
        }
    }
    
    init(authUseCase: AuthUseCase, coordinator: AuthCoordinator) {
        self.authUseCase = authUseCase
        self.coordinator = coordinator
        super.init()
    }
    
    private func validateInputs() {
        isInputValid = isEmailValid && isPasswordValid
    }
    
    @MainActor
    func performLogin() {
        guard isInputValid else { return }
        
        state = .loading
        
        Task {
            do {
                let user = try await authUseCase.executeLogin(email: email, password: password)
                state = .idle
                coordinator?.didLoginSuccessfully(user: user)
            } catch {
                state = .error(error.localizedDescription)
                errorMessage = error.localizedDescription
            }
        }
    }
}
