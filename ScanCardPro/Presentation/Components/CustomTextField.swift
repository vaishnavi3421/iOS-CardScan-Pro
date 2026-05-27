//
//  CustomTextField.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class CustomTextField: UITextField {
    
    var isError = false {
        didSet {
            updateBorder()
        }
    }
    
    private var padding: UIEdgeInsets {
        let rightPadding: CGFloat = (rightView != nil && rightViewMode != .never) ? 48 : 16
        let leftPadding: CGFloat = (leftView != nil && leftViewMode != .never) ? 48 : 16
        return UIEdgeInsets(top: 12, left: leftPadding, bottom: 12, right: rightPadding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = AppConstants.Style.cornerRadius
        layer.borderWidth = 1.0
        textColor = .label
        font = .systemFont(ofSize: 15, weight: .medium)
        tintColor = AppConstants.Style.primaryColor
        
        // Custom focus animations
        addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        updateBorder()
    }
    
    private func updateBorder() {
        let targetColor = isError ? AppConstants.Style.errorColor : (isFirstResponder ? AppConstants.Style.primaryColor : UIColor.systemGray4)
        let targetWidth: CGFloat = (isError || isFirstResponder) ? 1.5 : 1.0
        let targetBg: UIColor = isFirstResponder ? .systemBackground : .secondarySystemBackground
        
        UIView.animate(withDuration: 0.25) {
            self.layer.borderColor = targetColor.cgColor
            self.layer.borderWidth = targetWidth
            self.backgroundColor = targetBg
        }
    }
    
    // MARK: - Insets / Margins Override
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // MARK: - Actions
    
    @objc private func didBeginEditing() {
        updateBorder()
    }
    
    @objc private func didEndEditing() {
        updateBorder()
    }
    
    func setErrorState(_ hasError: Bool) {
        self.isError = hasError
    }
}
