//
//  BaseViewController.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let loadingOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private let offlineBar = OfflineStatusBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.Style.backgroundColor
        setupOfflineBar()
        
        // Listen to connectivity to slide offline bar
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityChanged),
            name: .connectivityChanged,
            object: nil
        )
        
        // Initial setup
        updateOfflineBarState(isConnected: NetworkMonitor.shared.isConnected)
    }
    
    // MARK: - Offline Handling
    
    private func setupOfflineBar() {
        view.addSubview(offlineBar)
        
        NSLayoutConstraint.activate([
            offlineBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            offlineBar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @objc private func connectivityChanged(notification: Notification) {
        guard let isConnected = notification.userInfo?["isConnected"] as? Bool else { return }
        updateOfflineBarState(isConnected: isConnected)
    }
    
    private func updateOfflineBarState(isConnected: Bool) {
        offlineBar.setConnected(isConnected)
    }
    
    // MARK: - Loading Indicator
    
    func showLoading() {
        guard loadingOverlay.superview == nil else { return }
        view.addSubview(loadingOverlay)
        
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    func hideLoading() {
        loadingOverlay.removeFromSuperview()
    }
    
    // MARK: - Toast Alerts
    
    enum ToastType {
        case success
        case error
        case info
    }
    
    func showToast(message: String, type: ToastType = .info) {
        let toastContainer = UIView()
        toastContainer.layer.cornerRadius = 8
        toastContainer.clipsToBounds = true
        toastContainer.alpha = 0
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .success:
            toastContainer.backgroundColor = AppConstants.Style.successColor
        case .error:
            toastContainer.backgroundColor = AppConstants.Style.errorColor
        case .info:
            toastContainer.backgroundColor = AppConstants.Style.primaryColor
        }
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = message
        label.translatesAutoresizingMaskIntoConstraints = false
        
        toastContainer.addSubview(label)
        view.addSubview(toastContainer)
        
        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            toastContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            toastContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            toastContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            label.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -8)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            toastContainer.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0
            }) { _ in
                toastContainer.removeFromSuperview()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
