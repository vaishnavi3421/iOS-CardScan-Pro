//
//  OfflineStatusBar.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class OfflineStatusBar: UIView {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        alpha = 0
        
        addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setConnected(_ isConnected: Bool) {
        if isConnected {
            // Transition back online
            statusLabel.text = "🟢 Back Online - Synchronizing..."
            backgroundColor = AppConstants.Style.successColor
            
            // Show briefly, then hide
            UIView.animate(withDuration: 0.3, animations: {
                self.isHidden = false
                self.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                    self.alpha = 0
                }) { _ in
                    self.isHidden = true
                }
            }
        } else {
            // Transition offline
            statusLabel.text = "⚠️ Offline Mode - Local Persistence Enabled"
            backgroundColor = AppConstants.Style.accentColor
            
            // Stay visible
            UIView.animate(withDuration: 0.3) {
                self.isHidden = false
                self.alpha = 1.0
            }
        }
    }
}
