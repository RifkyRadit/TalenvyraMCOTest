//
//  NewsArticlesRouter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

class NewsArticlesRouter: NewsArticlesRouterProtocol {
    static func createModuleNewsArticles(withSourceId sourceId: String, sourceName: String) -> UIViewController {
        let view = NewsArticlesViewController()
        let presenter = NewsArticlesPresenter(sourceId: sourceId, sourceName: sourceName)
        let interactor = NewsArticlesInteractor()
        let router = NewsArticlesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToDetail(from view: NewsArticlesViewProtocol?, withUrl url: String) {
        guard let newsArticlesVC = view as? UIViewController else { return }
        
        let articleDetailVC = ArticleDetailRouter.createModule(withUrl: url)
        newsArticlesVC.navigationController?.pushViewController(articleDetailVC, animated: true)
    }
}
