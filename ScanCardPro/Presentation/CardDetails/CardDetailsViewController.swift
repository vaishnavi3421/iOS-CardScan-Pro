//
//  CardDetailsViewController.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class CardDetailsViewController: BaseViewController {
    
    private let viewModel: CardDetailsViewModel
    
    // MARK: - UI Components
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Style.cardBackgroundColor
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = AppConstants.Style.shadowOpacity * 1.5
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let initialCircle: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Style.primaryColor.withAlphaComponent(0.1)
        view.layer.cornerRadius = 32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let initialLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConstants.Style.primaryColor
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let designationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConstants.Style.primaryColor
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Detail rows stack view
    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let emailRow = DetailRowView(iconName: "envelope.fill", title: "Email")
    private let phoneRow = DetailRowView(iconName: "phone.fill", title: "Phone")
    private let websiteRow = DetailRowView(iconName: "globe", title: "Website")
    private let addressRow = DetailRowView(iconName: "mappin.and.ellipse", title: "Address")
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Edit Contact Details", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = AppConstants.Style.primaryColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = AppConstants.Style.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Remove Card", for: .normal)
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.setTitleColor(AppConstants.Style.errorColor, for: .normal)
        button.tintColor = AppConstants.Style.errorColor
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.borderColor = AppConstants.Style.errorColor.cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = AppConstants.Style.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    init(viewModel: CardDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        configureView()
    }
    
    // MARK: - UI Design
    
    private func setupUI() {
        title = "Card Details"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(cardContainer)
        cardContainer.addSubview(initialCircle)
        initialCircle.addSubview(initialLabel)
        cardContainer.addSubview(nameLabel)
        cardContainer.addSubview(designationLabel)
        cardContainer.addSubview(companyLabel)
        
        view.addSubview(detailStack)
        detailStack.addArrangedSubview(emailRow)
        detailStack.addArrangedSubview(phoneRow)
        detailStack.addArrangedSubview(websiteRow)
        detailStack.addArrangedSubview(addressRow)
        
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46),
            cardContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            initialCircle.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 20),
            initialCircle.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            initialCircle.widthAnchor.constraint(equalToConstant: 64),
            initialCircle.heightAnchor.constraint(equalToConstant: 64),
            
            initialLabel.centerXAnchor.constraint(equalTo: initialCircle.centerXAnchor),
            initialLabel.centerYAnchor.constraint(equalTo: initialCircle.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 24),
            
            designationLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 20),
            designationLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -20),
            designationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            companyLabel.leadingAnchor.constraint(equalTo: initialCircle.trailingAnchor, constant: 20),
            companyLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -20),
            companyLabel.topAnchor.constraint(equalTo: designationLabel.bottomAnchor, constant: 6),
            companyLabel.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -24),
            
            detailStack.topAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: 32),
            detailStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            detailStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            editButton.topAnchor.constraint(equalTo: detailStack.bottomAnchor, constant: 40),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureView() {
        let card = viewModel.card
        nameLabel.text = card.personName
        designationLabel.text = card.designation
        companyLabel.text = card.companyName
        
        if let first = card.personName.first {
            initialLabel.text = String(first).uppercased()
        }
        
        emailRow.setValue(card.emailId.isEmpty ? "Not Available" : card.emailId)
        phoneRow.setValue(card.phoneNumber.isEmpty ? "Not Available" : card.phoneNumber)
        websiteRow.setValue(card.webSiteURL.isEmpty ? "Not Available" : card.webSiteURL)
        addressRow.setValue(card.address.isEmpty ? "No Address Provided" : card.address)
    }
    
    // MARK: - Reactive Bindings
    
    private func bindViewModel() {
        viewModel.onCardReloaded = { [weak self] in
            guard let self = self else { return }
            self.configureView()
            self.showToast(message: "Card updated successfully.", type: .success)
        }
        
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.showLoading()
            default:
                self.hideLoading()
            }
        }
        
        viewModel.onErrorMessage = { [weak self] message in
            guard let self = self else { return }
            self.showToast(message: message, type: .error)
        }
    }
    
    // MARK: - Actions
    
    @objc private func editTapped() {
        viewModel.editCard()
    }
    
    @objc private func deleteTapped() {
        let alert = UIAlertController(title: "Remove Card", message: "Are you sure you want to delete this business card permanently?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteCard()
        }))
        present(alert, animated: true)
    }
}

// MARK: - Helper Detail Info Row View
private final class DetailRowView: UIView {
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = AppConstants.Style.primaryColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(iconName: String, title: String) {
        super.init(frame: .zero)
        setupView(iconName: iconName, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(iconName: String, title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        
        iconView.image = UIImage(systemName: iconName)
        titleLabel.text = title.uppercased()
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}
