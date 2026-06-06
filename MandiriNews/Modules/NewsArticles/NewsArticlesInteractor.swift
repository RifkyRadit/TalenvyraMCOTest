//
//  NewsArticlesInteractor.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import Foundation

class NewsArticlesInteractor: NewsArticlesInteractorInputProtocol {
    weak var presenter: NewsArticlesInteractorOutputProtocol?

    func fetchArticles(withSourceId sourceId: String, page: Int, querySearch: String?) {
        Task {
            do {
                var parameters: [String: Any] = [
                    "sources": sourceId,
                    "page": page,
                    "pageSize": 15
                ]
                
                if let query = querySearch {
                    parameters["q"] = query
                }
                
                let response: ArticlesResponse = try await APIService.shared.request(endpoint: "everything", parameters: parameters)
                await MainActor.run {
                    self.presenter?.didFetchArticlesSuccessfully(response.articles, totalResults: response.totalResults)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didFetchArticlesFailed(withError: error)
                }
            }
        }
    }
}
