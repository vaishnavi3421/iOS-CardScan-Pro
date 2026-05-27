//
//  VisitingCardListViewController.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

final class VisitingCardListViewController: BaseViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    private let viewModel: VisitingCardViewModel
    private let currentEmployeeId = "34562" // Stubbed matching API response employee codes
    
    // MARK: - UI Components
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search name, title, or company..."
        sc.searchBar.delegate = self
        return sc
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.register(VisitingCardTableViewCell.self, forCellReuseIdentifier: VisitingCardTableViewCell.reuseIdentifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let refreshControl = UIRefreshControl()
    private let emptyStateView = EmptyStateView()
    
    // Floating Share Bar at the bottom
    private let shareBar: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Style.primaryColor
        view.layer.cornerRadius = 16
        view.layer.shadowColor = AppConstants.Style.primaryColor.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share Selected Cards", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Diffable DataSource Section
    
    private var dataSource: UITableViewDiffableDataSource<Int, String>!
    
    // MARK: - Initializer
    
    init(viewModel: VisitingCardViewModel = VisitingCardViewModel()) {
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
        setupDataSource()
        bindViewModel()
        
        // Initial Fetch
        viewModel.fetchVisitingCards(employeeId: currentEmployeeId)
    }
    
    // MARK: - Layout Setup
    
    private func setupUI() {
        title = "Corporate Cards"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add manual scan card button
        let addBtn = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBtn
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(shareBar)
        shareBar.addSubview(shareButton)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        shareButton.addTarget(self, action: #selector(shareSelectedCardsTapped), for: .touchUpInside)
        
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Floating share bar constraint
            shareBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            shareBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            shareBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            shareBar.heightAnchor.constraint(equalToConstant: 54),
            
            shareButton.leadingAnchor.constraint(equalTo: shareBar.leadingAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: shareBar.trailingAnchor, constant: -16),
            shareButton.topAnchor.constraint(equalTo: shareBar.topAnchor),
            shareButton.bottomAnchor.constraint(equalTo: shareBar.bottomAnchor)
        ])
    }
    
    // MARK: - Diffable Setup
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView) { [weak self] (tv, indexPath, cardId) -> UITableViewCell? in
            guard let self = self else { return nil }
            guard let cell = tv.dequeueReusableCell(withIdentifier: VisitingCardTableViewCell.reuseIdentifier, for: indexPath) as? VisitingCardTableViewCell else {
                return UITableViewCell()
            }
            
            if let card = self.viewModel.filteredCards.first(where: { $0.id == cardId }) {
                let isSelected = self.viewModel.selectedCards.contains(card.visitingCardId)
                cell.configure(with: card, isSelected: isSelected)
            }
            return cell
        }
        
        dataSource.defaultRowAnimation = .fade
    }
    
    private func applySnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.filteredCards.map { $0.id })
        
        dataSource.apply(snapshot, animatingDifferences: animated)
        emptyStateView.isHidden = !viewModel.filteredCards.isEmpty
        
        updateShareBarState()
    }
    
    // MARK: - Reactive Bindings
    
    private func bindViewModel() {
        viewModel.onCardsLoaded = { [weak self] in
            guard let self = self else { return }
            self.applySnapshot()
        }
        
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            switch state {
            case .loading:
                if !self.refreshControl.isRefreshing {
                    self.showLoading()
                }
            default:
                self.hideLoading()
            }
        }
        
        viewModel.onErrorMessage = { [weak self] message in
            guard let self = self else { return }
            self.showToast(message: message, type: .error)
        }
        
        viewModel.onSuccessMessage = { [weak self] message in
            guard let self = self else { return }
            self.showToast(message: message, type: .success)
        }
    }
    
    // MARK: - Share Bar Handler
    
    private func updateShareBarState() {
        let count = viewModel.selectedCards.count
        let shouldShow = count > 0
        
        shareButton.setTitle(" Share Selected Cards (\(count))", for: .normal)
        
        guard shareBar.isHidden == shouldShow else { return }
        
        if shouldShow {
            shareBar.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.shareBar.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.shareBar.alpha = 0
            }) { _ in
                self.shareBar.isHidden = true
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleRefresh() {
        viewModel.fetchVisitingCards(employeeId: currentEmployeeId)
    }
    
    @objc private func addTapped() {
        let addEditVC = AddEditVisitingCardViewController(viewModel: viewModel, card: nil)
        navigationController?.pushViewController(addEditVC, animated: true)
    }
    
    @objc private func shareSelectedCardsTapped() {
        let alert = UIAlertController(title: "Share Cards", message: "Enter creator name to share selected corporate cards:", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Creator / Employee Name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Share Now", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let creatorName = alert.textFields?.first?.text ?? "sys"
            self.viewModel.shareVisitingCards(employeeCode: self.currentEmployeeId, creator: creatorName)
        }))
        
        present(alert, animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchQuery = searchController.searchBar.text ?? ""
    }
}

// MARK: - UITableViewDelegate & Swipe Actions
extension VisitingCardListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cardId = dataSource.itemIdentifier(for: indexPath),
              let card = viewModel.filteredCards.first(where: { $0.id == cardId }) else { return }
        
        // Toggle selection for batch operations
        viewModel.toggleSelection(for: card.visitingCardId)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cardId = dataSource.itemIdentifier(for: indexPath),
              let card = viewModel.filteredCards.first(where: { $0.id == cardId }) else { return nil }
        
        // 1. Delete swipe action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            let alert = UIAlertController(title: "Remove Card", message: "Confirm card deletion?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion(false) })
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.viewModel.deleteVisitingCard(id: card.visitingCardId, employeeCode: self.currentEmployeeId)
                completion(true)
            })
            self.present(alert, animated: true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = AppConstants.Style.errorColor
        
        // 2. Edit swipe action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let addEditVC = AddEditVisitingCardViewController(viewModel: self.viewModel, card: card)
            self.navigationController?.pushViewController(addEditVC, animated: true)
            completion(true)
        }
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = AppConstants.Style.primaryColor
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
