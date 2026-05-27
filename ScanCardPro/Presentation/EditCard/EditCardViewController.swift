//
//  EditCardViewController.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class EditCardViewController: BaseViewController {
    
    private let viewModel: EditCardViewModel
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.keyboardDismissMode = .onDrag
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let formHeader: UILabel = {
        let label = UILabel()
        label.text = "Update Card Details"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameField = FormFieldView(placeholder: "Contact Full Name *", iconName: "person.fill")
    private let designationField = FormFieldView(placeholder: "Designation *", iconName: "briefcase.fill")
    private let companyField = FormFieldView(placeholder: "Company Name", iconName: "building.2.fill")
    private let phoneField = FormFieldView(placeholder: "Phone Number *", iconName: "phone.fill", keyboardType: .phonePad)
    private let emailField = FormFieldView(placeholder: "Email Address", iconName: "envelope.fill", keyboardType: .emailAddress)
    private let branchField = FormFieldView(placeholder: "Branch Name", iconName: "mappin.circle.fill")
    private let addressField = FormFieldView(placeholder: "Office Address", iconName: "map.fill")
    private let websiteField = FormFieldView(placeholder: "Website URL", iconName: "globe", keyboardType: .URL)
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Card Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.Style.primaryColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = AppConstants.Style.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    init(viewModel: EditCardViewModel) {
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
        registerKeyboardNotifications()
        bindViewModel()
        populateFormDetails()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Edit Card"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(formHeader)
        contentView.addSubview(nameField)
        contentView.addSubview(designationField)
        contentView.addSubview(companyField)
        contentView.addSubview(phoneField)
        contentView.addSubview(emailField)
        contentView.addSubview(branchField)
        contentView.addSubview(addressField)
        contentView.addSubview(websiteField)
        contentView.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            formHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            formHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            nameField.topAnchor.constraint(equalTo: formHeader.bottomAnchor, constant: 16),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            designationField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            designationField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            designationField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            companyField.topAnchor.constraint(equalTo: designationField.bottomAnchor, constant: 16),
            companyField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            companyField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            phoneField.topAnchor.constraint(equalTo: companyField.bottomAnchor, constant: 16),
            phoneField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            phoneField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            branchField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            branchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            branchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            addressField.topAnchor.constraint(equalTo: branchField.bottomAnchor, constant: 16),
            addressField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            addressField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            websiteField.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 16),
            websiteField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            websiteField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            saveButton.topAnchor.constraint(equalTo: websiteField.bottomAnchor, constant: 36),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func populateFormDetails() {
        let card = viewModel.card
        nameField.text = card.personName
        designationField.text = card.designation
        companyField.text = card.companyName
        phoneField.text = card.phoneNumber
        emailField.text = card.emailId
        branchField.text = card.branchName
        addressField.text = card.address
        websiteField.text = card.webSiteURL
    }
    
    private func bindViewModel() {
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
    
    @objc private func saveTapped() {
        view.endEditing(true)
        
        nameField.showErrorHighlight(nameField.text.isEmpty)
        designationField.showErrorHighlight(designationField.text.isEmpty)
        phoneField.showErrorHighlight(phoneField.text.isEmpty)
        
        viewModel.saveCard(
            personName: nameField.text,
            designation: designationField.text,
            companyName: companyField.text,
            phoneNumber: phoneField.text,
            emailId: emailField.text,
            branchName: branchField.text,
            address: addressField.text,
            webSiteURL: websiteField.text
        )
    }
    
    // MARK: - Keyboard Handling
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let height = keyboardFrame.cgRectValue.height
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: height + 12, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - Inline Helper Form Field View
private final class FormFieldView: UIView {
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = AppConstants.Style.primaryColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let textField = CustomTextField()
    
    var text: String {
        get { return textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    init(placeholder: String, iconName: String, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        setupLayout(placeholder: placeholder, iconName: iconName, keyboardType: keyboardType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(placeholder: String, iconName: String, keyboardType: UIKeyboardType) {
        translatesAutoresizingMaskIntoConstraints = false
        
        iconView.image = UIImage(systemName: iconName)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = (keyboardType == .emailAddress || keyboardType == .URL) ? .none : .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            textField.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func showErrorHighlight(_ hasError: Bool) {
        textField.setErrorState(hasError)
    }
}
