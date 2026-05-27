//
//  HomeViewController.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    private let viewModel: HomeViewModel
    
    // MARK: - UI Components
    
    private let welcomeCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Style.primaryColor
        view.layer.cornerRadius = AppConstants.Style.cornerRadius
        view.layer.shadowColor = AppConstants.Style.primaryColor.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome,"
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let employeeIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.85)
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Metrics layout container
    private let metricsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let totalMetricCard = MetricCardView(title: "Total Cards", iconName: "creditcard.fill", countColor: .label)
    private let syncedMetricCard = MetricCardView(title: "Synced", iconName: "checkmark.circle.fill", countColor: AppConstants.Style.successColor)
    private let pendingMetricCard = MetricCardView(title: "Pending Sync", iconName: "exclamationmark.triangle.fill", countColor: AppConstants.Style.accentColor)
    
    private let scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Scan Business Card", for: .normal)
        button.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = AppConstants.Style.primaryColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = AppConstants.Style.cornerRadius
        button.layer.shadowColor = AppConstants.Style.primaryColor.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" View Scanned Cards", for: .normal)
        button.setImage(UIImage(systemName: "list.bullet.rectangle.fill"), for: .normal)
        button.setTitleColor(AppConstants.Style.primaryColor, for: .normal)
        button.tintColor = AppConstants.Style.primaryColor
        button.backgroundColor = .systemBackground
        button.layer.borderColor = AppConstants.Style.primaryColor.cgColor
        button.layer.borderWidth = 1.5
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = AppConstants.Style.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    init(viewModel: HomeViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.loadDashboardData()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add logout button
        let logoutBtn = UIBarButtonItem(image: UIImage(systemName: "power"), style: .plain, target: self, action: #selector(logoutTapped))
        logoutBtn.tintColor = AppConstants.Style.errorColor
        navigationItem.rightBarButtonItem = logoutBtn
        
        view.addSubview(welcomeCard)
        welcomeCard.addSubview(welcomeLabel)
        welcomeCard.addSubview(userNameLabel)
        welcomeCard.addSubview(employeeIdLabel)
        
        view.addSubview(metricsStack)
        metricsStack.addArrangedSubview(totalMetricCard)
        metricsStack.addArrangedSubview(syncedMetricCard)
        metricsStack.addArrangedSubview(pendingMetricCard)
        
        view.addSubview(scanButton)
        view.addSubview(viewListButton)
        
        scanButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
        viewListButton.addTarget(self, action: #selector(viewListTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            welcomeCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            welcomeCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            welcomeLabel.topAnchor.constraint(equalTo: welcomeCard.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: welcomeCard.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: welcomeCard.trailingAnchor, constant: -20),
            
            userNameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            userNameLabel.leadingAnchor.constraint(equalTo: welcomeCard.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: welcomeCard.trailingAnchor, constant: -20),
            
            employeeIdLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            employeeIdLabel.leadingAnchor.constraint(equalTo: welcomeCard.leadingAnchor, constant: 20),
            employeeIdLabel.trailingAnchor.constraint(equalTo: welcomeCard.trailingAnchor, constant: -20),
            employeeIdLabel.bottomAnchor.constraint(equalTo: welcomeCard.bottomAnchor, constant: -20),
            
            metricsStack.topAnchor.constraint(equalTo: welcomeCard.bottomAnchor, constant: 24),
            metricsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            metricsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            metricsStack.heightAnchor.constraint(equalToConstant: 110),
            
            scanButton.topAnchor.constraint(equalTo: metricsStack.bottomAnchor, constant: 36),
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            scanButton.heightAnchor.constraint(equalToConstant: 54),
            
            viewListButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 16),
            viewListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            viewListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            viewListButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    // MARK: - Reactive Bindings
    
    private func bindViewModel() {
        userNameLabel.text = viewModel.employeeName
        employeeIdLabel.text = "Employee ID: \(viewModel.employeeId)"
        
        viewModel.onMetricsUpdated = { [weak self] metrics in
            guard let self = self else { return }
            self.totalMetricCard.updateCount(metrics.totalCount)
            self.syncedMetricCard.updateCount(metrics.syncedCount)
            self.pendingMetricCard.updateCount(metrics.pendingCount)
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
    }
    
    // MARK: - Actions
    
    @objc private func scanTapped() {
        viewModel.navigateToScanner()
    }
    
    @objc private func viewListTapped() {
        viewModel.navigateToCardList()
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to end your session?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.performLogout()
        }))
        present(alert, animated: true)
    }
}

// MARK: - Helper Metric Card Subview
private final class MetricCardView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    init(title: String, iconName: String, countColor: UIColor) {
        super.init(frame: .zero)
        setupView(title: title, iconName: iconName, countColor: countColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String, iconName: String, countColor: UIColor) {
        backgroundColor = AppConstants.Style.cardBackgroundColor
        layer.cornerRadius = AppConstants.Style.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = AppConstants.Style.shadowOpacity
        layer.shadowRadius = AppConstants.Style.shadowRadius
        layer.shadowOffset = AppConstants.Style.shadowOffset
        
        titleLabel.text = title.uppercased()
        countLabel.textColor = countColor
        iconView.image = UIImage(systemName: iconName)
        if countColor != .label {
            iconView.tintColor = countColor.withAlphaComponent(0.8)
        }
        
        addSubview(iconView)
        addSubview(countLabel)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            countLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func updateCount(_ count: Int) {
        countLabel.text = "\(count)"
    }
}
