//
//  NewsSourcesProtocols.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

protocol NewsSourcesViewProtocol: AnyObject {
    var presenter: NewsSourcesPresenterProtocol? { get set }
    func showListSources(_ sources: [String])
    func showErrorState(_ message: NetworkError)
    func showLoading()
    func hideLoading()
}

protocol NewsSourcesPresenterProtocol: AnyObject {
    var view: NewsSourcesViewProtocol? { get set }
    var interactor: NewsSourcesInteractorInputProtocol? { get set }
    var router: NewsSourcesRouterProtocol? { get set }
    
    func viewDidLoad()
    func search(query: String)
    func loadMore()
    func didSelectedSource(at index: Int)
}

protocol NewsSourcesInteractorInputProtocol: AnyObject {
    var presenter: NewsSourcesInteractorOutputProtocol? { get set }
    func fetchSources(withCategory category: String)
}

protocol NewsSourcesInteractorOutputProtocol: AnyObject {
    func didFetchSourcesSuccessfully(_ sources: [NewsSource])
    func didFetchSourcesFailed(_ error: Error)
}

protocol NewsSourcesRouterProtocol: AnyObject {
    static func createModuleNewsSources(withCategory category: String) -> UIViewController
    func navigateToArticles(from view: NewsSourcesViewProtocol?, withSourceId id: String, sourceName: String)
}
