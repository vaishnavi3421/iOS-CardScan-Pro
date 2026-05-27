//
//  BaseViewModel.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation

class BaseViewModel {
    
    // Binding closures representing standard reactive bindings without heavy external frameworks (like Combine or RxSwift)
    var onStateChange: ((ViewModelState) -> Void)?
    var onErrorMessage: ((String) -> Void)?
    
    enum ViewModelState {
        case idle
        case loading
        case empty
        case error(String)
    }
    
    var state: ViewModelState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onStateChange?(self.state)
            }
        }
    }
    
    var errorMessage: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onErrorMessage?(self.errorMessage)
            }
        }
    }
}
