//
//  ScanCardViewController.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit
import VisionKit

final class ScanCardViewController: BaseViewController, VNDocumentCameraViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let viewModel: ScanCardViewModel
    
    // MARK: - UI Components
    
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
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap below to scan a visiting card.\nMake sure the card is well-lit and fits the frame."
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Launch Camera Scanner", for: .normal)
        button.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = AppConstants.Style.primaryColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = AppConstants.Style.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Choose from Photo Library", for: .normal)
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.setTitleColor(AppConstants.Style.primaryColor, for: .normal)
        button.tintColor = AppConstants.Style.primaryColor
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    init(viewModel: ScanCardViewModel) {
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Scan Card"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(containerView)
        containerView.addSubview(instructionLabel)
        containerView.addSubview(captureButton)
        containerView.addSubview(galleryButton)
        
        captureButton.addTarget(self, action: #selector(launchScanner), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(launchPhotoLibrary), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            instructionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 36),
            instructionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            instructionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            captureButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 32),
            captureButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            captureButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            captureButton.heightAnchor.constraint(equalToConstant: 50),
            
            galleryButton.topAnchor.constraint(equalTo: captureButton.bottomAnchor, constant: 16),
            galleryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            galleryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            galleryButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -36),
            galleryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Bindings
    
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
    
    @objc private func launchScanner() {
        #if targetEnvironment(simulator)
        showToast(message: "VisionKit Document Camera is not available in simulator. Falling back to Photo Library.", type: .info)
        launchPhotoLibrary()
        #else
        guard VNDocumentCameraViewController.isSupported else {
            showToast(message: "Document scanning is not supported on this device. Falling back to Photo Library.", type: .error)
            launchPhotoLibrary()
            return
        }
        
        let docScanner = VNDocumentCameraViewController()
        docScanner.delegate = self
        present(docScanner, animated: true)
        #endif
    }
    
    @objc private func launchPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // MARK: - VNDocumentCameraViewControllerDelegate
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        
        // Retrieve the first scanned card page image
        guard scan.pageCount > 0 else { return }
        let image = scan.imageOfPage(at: 0)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            showToast(message: "Failed to compress image data.", type: .error)
            return
        }
        
        // Pass image data to viewModel
        viewModel.processCapturedImage(data: imageData)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        showToast(message: "Scanner failed: \(error.localizedDescription)", type: .error)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            showToast(message: "Failed to parse image data.", type: .error)
            return
        }
        
        viewModel.processCapturedImage(data: imageData)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
