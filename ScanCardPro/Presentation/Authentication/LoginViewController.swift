//
//  LoginViewController.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    private let viewModel: LoginViewModel
    
    // MARK: - UI Components
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            AppConstants.Style.primaryColor.withAlphaComponent(0.12).cgColor,
            AppConstants.Style.secondaryColor.withAlphaComponent(0.04).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 24
        view.layer.shadowColor = AppConstants.Style.primaryColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 0.15
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.separator.withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Screenshot 2026-05-26 at 1.32.20 PM")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "CardScan Pro"
        label.textColor = .label
        label.font = .systemFont(ofSize: 32, weight: .black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enterprise Business Card Scanner & Sync"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.06
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.separator.withAlphaComponent(0.4).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Employee Email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .secondaryLabel
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.Style.primaryColor.withAlphaComponent(0.6) // Starts disabled
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = AppConstants.Style.cornerRadius
        button.isEnabled = false
        
        button.layer.shadowColor = AppConstants.Style.primaryColor.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    init(viewModel: LoginViewModel) {
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.4)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Login Screen"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        
        view.addSubview(appTitleLabel)
        view.addSubview(appSubtitleLabel)
        
        view.addSubview(cardContainerView)
        cardContainerView.addSubview(emailTextField)
        cardContainerView.addSubview(passwordTextField)
        cardContainerView.addSubview(loginButton)
        
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        
        let toolbar = createKeyboardToolbar()
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailEditingEnded), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passwordEditingEnded), for: .editingDidEnd)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            logoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoContainerView.widthAnchor.constraint(equalToConstant: 96),
            logoContainerView.heightAnchor.constraint(equalToConstant: 96),
            
            logoImageView.topAnchor.constraint(equalTo: logoContainerView.topAnchor, constant: 8),
            logoImageView.bottomAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: -8),
            logoImageView.leadingAnchor.constraint(equalTo: logoContainerView.leadingAnchor, constant: 8),
            logoImageView.trailingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: -8),
            
            appTitleLabel.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 20),
            appTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            appSubtitleLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 8),
            appSubtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appSubtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            cardContainerView.topAnchor.constraint(equalTo: appSubtitleLabel.bottomAnchor, constant: 32),
            cardContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 28),
            loginButton.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            loginButton.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Reactive Bindings
    
    private func bindViewModel() {
        viewModel.onValidationStateChange = { [weak self] isValid in
            guard let self = self else { return }
            self.loginButton.isEnabled = isValid
            UIView.animate(withDuration: 0.25) {
                self.loginButton.backgroundColor = isValid ? AppConstants.Style.primaryColor : AppConstants.Style.primaryColor.withAlphaComponent(0.6)
                self.loginButton.layer.shadowOpacity = isValid ? 0.35 : 0.0
            }
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
    
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
        emailTextField.setErrorState(false)
    }
    
    @objc private func passwordChanged() {
        viewModel.password = passwordTextField.text ?? ""
        passwordTextField.setErrorState(false)
    }
    
    @objc private func loginTapped() {
        view.endEditing(true)
        viewModel.performLogin()
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let iconName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc private func emailEditingEnded() {
        let text = emailTextField.text ?? ""
        if text.isEmpty {
            emailTextField.setErrorState(false)
        } else {
            emailTextField.setErrorState(!viewModel.isEmailValid)
        }
    }
    
    @objc private func passwordEditingEnded() {
        let text = passwordTextField.text ?? ""
        if text.isEmpty {
            passwordTextField.setErrorState(false)
        } else {
            passwordTextField.setErrorState(!viewModel.isPasswordValid)
        }
    }
    
    // MARK: - Keyboard Accessory Helper
    
    private func createKeyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        toolbar.items = [flexSpace, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }
    
    @objc private func doneTapped() {
        view.endEditing(true)
    }
}
