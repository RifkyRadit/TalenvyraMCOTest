//
//  NewsSourcesPresenter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import Foundation

class NewsSourcesPresenter: NewsSourcesPresenterProtocol {
    weak var view: NewsSourcesViewProtocol?

    var interactor: NewsSourcesInteractorInputProtocol?
    var router: NewsSourcesRouterProtocol?

    private let selectedCategory: String
    private let pageSize = 15

    private var allSources: [NewsSource] = []
    private var searchQuery = ""
    private var displayedCount = 15
    private var isLoading = false

    init(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        self.displayedCount = pageSize
    }

    func viewDidLoad() {
        searchQuery = ""
        resetPagination()
        isLoading = true
        view?.showLoading()
        interactor?.fetchSources(withCategory: selectedCategory)
    }

    func search(query: String) {
        searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        resetPagination()
        applyFilter()
    }

    func loadMore() {
        guard !isLoading else { return }

        let filtered = filteredSources
        guard displayedCount < filtered.count else { return }

        displayedCount = min(displayedCount + pageSize, filtered.count)
        applyFilter()
    }

    func didSelectedSource(at index: Int) {
        let rows = displayedSources
        guard index < rows.count else { return }
        let sourceId = rows[index].id
        let sourceName = rows[index].name
        router?.navigateToArticles(from: view, withSourceId: sourceId, sourceName: sourceName)
    }
}

extension NewsSourcesPresenter: NewsSourcesInteractorOutputProtocol {
    func didFetchSourcesSuccessfully(_ sources: [NewsSource]) {
        isLoading = false
        view?.hideLoading()

        if sources.isEmpty {
            view?.showErrorState(.noData)
        } else {
            allSources = sources
            resetPagination()
            applyFilter()
        }
    }

    func didFetchSourcesFailed(_ error: any Error) {
        isLoading = false
        view?.hideLoading()

        if let networkError = error as? NetworkError {
            view?.showErrorState(networkError)
        } else {
            view?.showErrorState(.invalidURL)
        }
    }
}

private extension NewsSourcesPresenter {
    var filteredSources: [NewsSource] {
        guard !searchQuery.isEmpty else { return allSources }
        return allSources.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }

    var displayedSources: [NewsSource] {
        Array(filteredSources.prefix(displayedCount))
    }

    func resetPagination() {
        displayedCount = pageSize
    }

    func applyFilter() {
        view?.showListSources(displayedSources.map(\.name))
    }
}
