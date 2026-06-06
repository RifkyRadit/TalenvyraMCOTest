//
//  ArticleDetailRouter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 06/06/26.
//

import UIKit

class ArticleDetailRouter: ArticleDetailRouterProtocol {
    static func createModule(withUrl urlString: String) -> UIViewController {
        let view = ArticleDetailViewController()
        let presenter = ArticleDetailPresenter(urlString: urlString)
        let router = ArticleDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view
    }
}
