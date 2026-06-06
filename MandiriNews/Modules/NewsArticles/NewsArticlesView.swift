//
//  NewsArticlesView.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

class NewsArticlesViewController: UIViewController, NewsArticlesViewProtocol {
    var presenter: NewsArticlesPresenterProtocol?
    private var articles: [ArticleData] = []
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let stateContainerView = UIView()
    private let stateImageView = UIImageView()
    private let stateLabel = UILabel()
    
    private var searchTask: Task<Void, Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter?.screenTitle ?? "Articles"
        view.backgroundColor = .systemBackground
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupSearchController() {
        searchBar.placeholder = "Find the Articles..."
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsArticleCell.self, forCellReuseIdentifier: "articleCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        setupSearchController()
        setupTableView()
        
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        
        view.addSubview(stateContainerView)
        stateContainerView.translatesAutoresizingMaskIntoConstraints = false
        stateContainerView.isHidden = true
        
        stateContainerView.addSubview(stateImageView)
        stateContainerView.addSubview(stateLabel)
        stateImageView.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stateImageView.contentMode = .scaleAspectFit
        stateImageView.tintColor = .systemGray
        
        stateLabel.textAlignment = .center
        stateLabel.numberOfLines = 0
        stateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        stateLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            stateContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stateContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stateImageView.topAnchor.constraint(equalTo: stateContainerView.topAnchor),
            stateImageView.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),
            stateImageView.widthAnchor.constraint(equalToConstant: 80),
            stateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            stateLabel.topAnchor.constraint(equalTo: stateImageView.bottomAnchor, constant: 16),
            stateLabel.leadingAnchor.constraint(equalTo: stateContainerView.leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: stateContainerView.trailingAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: stateContainerView.bottomAnchor)
        ])
    }
    
    func showArticles(_ articles: [ArticleData]) {
        self.articles = articles
        stateContainerView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func showErrorState(_ error: NetworkError) {
        tableView.isHidden = true
        NetworkErrorPresenter.present(
            on: self,
            error: error,
            onRetry: { [weak self] in
                self?.presenter?.viewDidLoad()
            },
            onShowVisualState: { [weak self] iconName, message in
                self?.showEmptyState(iconName: iconName, message: message)
            }
        )
    }
    
    func showLoading() {
        stateContainerView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    private func showEmptyState(iconName: String, message: String) {
        stateImageView.image = UIImage(systemName: iconName)
        stateLabel.text = message
        stateContainerView.isHidden = false
    }
}

extension NewsArticlesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                presenter?.performSearch(with: searchText)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.performSearch(with: "")
    }
}

extension NewsArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NewsArticleCell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? NewsArticleCell else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        cell.configureCell(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectArticle(articles[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !articles.isEmpty, indexPath.row == articles.count - 1 else { return }
        presenter?.loadMoreArticlesIfNeeded()
    }
}
