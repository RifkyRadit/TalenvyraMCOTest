//
//  NewsSourcesView.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

class NewsSourcesViewController: UIViewController, NewsSourcesViewProtocol {
    var presenter: NewsSourcesPresenterProtocol?
    private let listScreenView = NewsListScreenView()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Sources"
        view.backgroundColor = .systemBackground
        setupSearchBar()
        setupListScreenView()
        presenter?.viewDidLoad()
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Find the Source of News"
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

    private func setupListScreenView() {
        listScreenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listScreenView)

        NSLayoutConstraint.activate([
            listScreenView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            listScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        listScreenView.onSelectItemAtIndex = { [weak self] index in
            self?.presenter?.didSelectedSource(at: index)
        }

        listScreenView.onReachEnd = { [weak self] in
            self?.presenter?.loadMore()
        }
    }

    func showListSources(_ sources: [String]) {
        listScreenView.setItems(sources)
        listScreenView.showContent()
    }

    func showErrorState(_ error: NetworkError) {
        listScreenView.hideList()

        NetworkErrorPresenter.present(
            on: self,
            error: error,
            onRetry: { [weak self] in
                self?.presenter?.viewDidLoad()
            },
            onShowVisualState: { [weak self] iconName, message in
                self?.listScreenView.showEmptyState(iconName: iconName, message: message)
            }
        )
    }

    func showLoading() {
        searchBar.text = ""
        listScreenView.showLoading(true)
    }

    func hideLoading() {
        listScreenView.showLoading(false)
    }
}

extension NewsSourcesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(query: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
