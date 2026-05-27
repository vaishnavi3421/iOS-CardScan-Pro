//
//  VisitingCardTableViewCell.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class VisitingCardTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "VisitingCardTableViewCell"
    
    // MARK: - UI Components
    
    private let cardContainer: UIView = {
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
    
    private let selectIndicator: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppConstants.Style.primaryColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let initialCircle: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Style.primaryColor.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let initialLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConstants.Style.primaryColor
        label.font = .systemFont(ofSize: 16, weight: .bold)
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
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConstants.Style.primaryColor
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "phone.fill"))
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "envelope.fill"))
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let branchTag: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.backgroundColor = AppConstants.Style.successColor.withAlphaComponent(0.85)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Design
    
    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardContainer)
        cardContainer.addSubview(selectIndicator)
        cardContainer.addSubview(initialCircle)
        initialCircle.addSubview(initialLabel)
        
        cardContainer.addSubview(nameLabel)
        cardContainer.addSubview(designationLabel)
        cardContainer.addSubview(companyLabel)
        
        cardContainer.addSubview(phoneIcon)
        cardContainer.addSubview(phoneLabel)
        cardContainer.addSubview(emailIcon)
        cardContainer.addSubview(emailLabel)
        cardContainer.addSubview(branchTag)
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Checkbox
            selectIndicator.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 12),
            selectIndicator.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            selectIndicator.widthAnchor.constraint(equalToConstant: 22),
            selectIndicator.heightAnchor.constraint(equalToConstant: 22),
            
            // Initials Circle
            initialCircle.leadingAnchor.constraint(equalTo: selectIndicator.trailingAnchor, constant: 12),
            initialCircle.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            initialCircle.widthAnchor.constraint(equalToConstant: 40),
            initialCircle.heightAnchor.constraint(equalToConstant: 40),
            
            initialLabel.centerXAnchor.constraint(equalTo: initialCircle.centerXAnchor),
            initialLabel.centerYAnchor.constraint(equalTo: initialCircle.centerYAnchor),
            
            // Person Name
            nameLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 14),
            nameLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 14),
            nameLabel.trailingAnchor.constraint(equalTo: branchTag.leadingAnchor, constant: -12),
            
            // Designation / Subtitle
            designationLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 14),
            designationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            designationLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -14),
            
            // Company
            companyLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 14),
            companyLabel.topAnchor.constraint(equalTo: designationLabel.bottomAnchor, constant: 2),
            companyLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -14),
            
            // Contact Phone Row
            phoneIcon.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 14),
            phoneIcon.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 10),
            phoneIcon.widthAnchor.constraint(equalToConstant: 12),
            phoneIcon.heightAnchor.constraint(equalToConstant: 12),
            
            phoneLabel.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 6),
            phoneLabel.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -14),
            
            // Contact Email Row
            emailIcon.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 14),
            emailIcon.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: 6),
            emailIcon.widthAnchor.constraint(equalToConstant: 12),
            emailIcon.heightAnchor.constraint(equalToConstant: 12),
            emailIcon.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -14),
            
            emailLabel.leadingAnchor.constraint(equalTo: emailIcon.trailingAnchor, constant: 6),
            emailLabel.centerYAnchor.constraint(equalTo: emailIcon.centerYAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -14),
            
            // Branch Badge at top right
            branchTag.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -14),
            branchTag.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 14),
            branchTag.widthAnchor.constraint(equalToConstant: 76),
            branchTag.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with card: VisitingCard, isSelected: Bool) {
        nameLabel.text = card.personName
        designationLabel.text = card.designation
        companyLabel.text = card.companyName.isEmpty ? "Independent / Corporate" : card.companyName
        phoneLabel.text = card.phoneNumber
        emailLabel.text = card.emailId
        branchTag.text = card.branchName.isEmpty ? "Corporate" : card.branchName.uppercased()
        
        if let char = card.personName.first {
            initialLabel.text = String(char).uppercased()
        } else {
            initialLabel.text = "C"
        }
        
        // Multi-card checkmark selection updates
        let iconName = isSelected ? "checkmark.circle.fill" : "circle"
        selectIndicator.image = UIImage(systemName: iconName)
        selectIndicator.tintColor = isSelected ? AppConstants.Style.primaryColor : .systemGray3
    }
}
