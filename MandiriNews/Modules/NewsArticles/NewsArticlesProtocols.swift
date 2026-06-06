//
//  NewsArticlesProtocols.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

protocol NewsArticlesViewProtocol: AnyObject {
    var presenter: NewsArticlesPresenterProtocol? { get set }
    func showArticles(_ articles: [ArticleData])
    func showErrorState(_ error: NetworkError)
    func showLoading()
    func hideLoading()
}

protocol NewsArticlesPresenterProtocol: AnyObject {
    var view: NewsArticlesViewProtocol? { get set }
    var interactor: NewsArticlesInteractorInputProtocol? { get set }
    var router: NewsArticlesRouterProtocol? { get set }
    var screenTitle: String { get }
    
    func viewDidLoad()
    func loadMoreArticlesIfNeeded()
    func performSearch(with query: String)
    func didSelectArticle(_ article: ArticleData)
}

protocol NewsArticlesInteractorInputProtocol: AnyObject {
    var presenter: NewsArticlesInteractorOutputProtocol? { get set }
    func fetchArticles(withSourceId sourceId: String, page: Int, querySearch: String?)
}

protocol NewsArticlesInteractorOutputProtocol: AnyObject {
    func didFetchArticlesSuccessfully(_ newArticles: [ArticleData], totalResults: Int)
    func didFetchArticlesFailed(withError error: Error)
}

protocol NewsArticlesRouterProtocol: AnyObject {
    static func createModuleNewsArticles(withSourceId sourceId: String, sourceName: String) -> UIViewController
    func navigateToDetail(from view: NewsArticlesViewProtocol?, withUrl url: String)
}
