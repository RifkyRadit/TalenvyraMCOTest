//
//  NewsSourcesRouter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

class NewsSourcesRouter: NewsSourcesRouterProtocol {
    static func createModuleNewsSources(withCategory category: String) -> UIViewController {
        let view = NewsSourcesViewController()
        let presenter: NewsSourcesPresenterProtocol & NewsSourcesInteractorOutputProtocol = NewsSourcesPresenter(selectedCategory: category)
        
        let interactor: NewsSourcesInteractorInputProtocol = NewsSourcesInteractor()
        let router: NewsSourcesRouterProtocol = NewsSourcesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToArticles(from view: NewsSourcesViewProtocol?, withSourceId id: String, sourceName: String) {
        guard let newsSourcesVC = view as? NewsSourcesViewController else { return }
        
        let newsArticlesVC = NewsArticlesRouter.createModuleNewsArticles(withSourceId: id, sourceName: sourceName)
        newsSourcesVC.navigationController?.pushViewController(newsArticlesVC, animated: true)
    }
}
