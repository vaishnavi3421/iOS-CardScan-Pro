//
//  BaseCardCell.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class BaseCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BaseCardCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Style.cardBackgroundColor
        view.layer.cornerRadius = AppConstants.Style.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = AppConstants.Style.shadowOpacity
        view.layer.shadowRadius = AppConstants.Style.shadowRadius
        view.layer.shadowOffset = AppConstants.Style.shadowOffset
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let initialCircle: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Style.primaryColor.withAlphaComponent(0.1)
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let initialLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConstants.Style.primaryColor
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let designationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConstants.Style.primaryColor
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let syncTag: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(initialCircle)
        initialCircle.addSubview(initialLabel)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(designationLabel)
        containerView.addSubview(companyLabel)
        containerView.addSubview(syncTag)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            initialCircle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            initialCircle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            initialCircle.widthAnchor.constraint(equalToConstant: 48),
            initialCircle.heightAnchor.constraint(equalToConstant: 48),
            
            initialLabel.centerXAnchor.constraint(equalTo: initialCircle.centerXAnchor),
            initialLabel.centerYAnchor.constraint(equalTo: initialCircle.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: syncTag.leadingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            
            designationLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 16),
            designationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            designationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            companyLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 16),
            companyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            companyLabel.topAnchor.constraint(equalTo: designationLabel.bottomAnchor, constant: 4),
            companyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            syncTag.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            syncTag.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            syncTag.widthAnchor.constraint(equalToConstant: 72),
            syncTag.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func configure(with card: VisitingCard) {
        nameLabel.text = card.personName
        designationLabel.text = card.designation
        companyLabel.text = card.companyName
        
        if let firstChar = card.personName.first {
            initialLabel.text = String(firstChar).uppercased()
        } else {
            initialLabel.text = "C"
        }
        
        // Dynamically style sync status tags
        switch card.syncStatus {
        case .synced:
            syncTag.text = "SYNCED"
            syncTag.backgroundColor = AppConstants.Style.successColor.withAlphaComponent(0.85)
        case .pendingUpload:
            syncTag.text = "OFFLINE"
            syncTag.backgroundColor = AppConstants.Style.accentColor.withAlphaComponent(0.85)
        case .pendingUpdate:
            syncTag.text = "PENDING"
            syncTag.backgroundColor = AppConstants.Style.secondaryColor.withAlphaComponent(0.85)
        case .pendingDelete:
            syncTag.text = "DELETING"
            syncTag.backgroundColor = AppConstants.Style.errorColor.withAlphaComponent(0.85)
        }
    }
}
