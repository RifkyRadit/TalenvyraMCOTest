//
//  NewsCategoriesView.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 03/06/26.
//

import UIKit

class NewsCategoriesViewController: UIViewController, NewsCategoriesViewProtocol {
    var presenter: NewsCategoriesPresenterProtocol?
    private let listScreenView = NewsListScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Categories"
        view.backgroundColor = .systemBackground
        setupListScreenView()
        presenter?.viewDidLoad()
    }

    private func setupListScreenView() {
        listScreenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listScreenView)

        NSLayoutConstraint.activate([
            listScreenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        listScreenView.onSelectItem = { [weak self] category in
            self?.presenter?.didSelectedCategory(category)
        }
    }

    func showCategories(_ categories: [String]) {
        listScreenView.setItems(categories)
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
        listScreenView.showLoading(true)
    }

    func hideLoading() {
        listScreenView.showLoading(false)
    }
}
