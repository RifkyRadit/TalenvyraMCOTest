//
//  NewsArticlesPresenter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import Foundation

class NewsArticlesPresenter: NewsArticlesPresenterProtocol {
    weak var view: NewsArticlesViewProtocol?
    var interactor: NewsArticlesInteractorInputProtocol?
    var router: NewsArticlesRouterProtocol?
    
    private var articles: [ArticleData] = []
    private var currentPage = 1
    private var totalResults = 0
    private var isFetching = false
    private var currentSearchQuery: String? = nil
    
    private let sourceId: String
    private let sourceName: String
    
    var screenTitle: String { sourceName }
    
    init(sourceId: String, sourceName: String) {
        self.sourceId = sourceId
        self.sourceName = sourceName
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    private func loadData() {
        guard !isFetching else { return }
        
        if currentPage > 1 && articles.count >= totalResults {
            return
        }

        isFetching = true
        if currentPage == 1 {
            view?.showLoading()
        }
        
        interactor?.fetchArticles(withSourceId: sourceId, page: currentPage, querySearch: currentSearchQuery)
    }
    
    func loadMoreArticlesIfNeeded() {
        loadData()
    }
    
    func performSearch(with query: String) {
        currentSearchQuery = query.isEmpty ? nil : query
        currentPage = 1
        articles.removeAll()
        totalResults = 0
        isFetching = false
        
        loadData()
    }
    
    func didSelectArticle(_ article: ArticleData) {
        guard let url = article.url else { return }
        router?.navigateToDetail(from: view, withUrl: url)
    }
}

extension NewsArticlesPresenter: NewsArticlesInteractorOutputProtocol {
    func didFetchArticlesSuccessfully(_ newArticles: [ArticleData], totalResults: Int) {
        isFetching = false
        view?.hideLoading()
        
        self.totalResults = totalResults
        
//        let validArticles = articles.filter { $0.title != "[Removed]" }
        self.articles.append(contentsOf: newArticles)
        
        if articles.isEmpty {
            view?.showErrorState(.noData)
        } else {
            view?.showArticles(self.articles)
            currentPage += 1
        }
    }
    
    func didFetchArticlesFailed(withError error: Error) {
        isFetching = false
        view?.hideLoading()
        view?.showErrorState(.invalidURL)
    }
}
