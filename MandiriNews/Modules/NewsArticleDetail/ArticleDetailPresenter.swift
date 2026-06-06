//
//  ArticleDetailPresenter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 06/06/26.
//

import Foundation

class ArticleDetailPresenter: ArticleDetailPresenterProtocol {
    weak var view: ArticleDetailViewProtocol?
    var router: ArticleDetailRouterProtocol?
    
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func viewDidLoad() {
        view?.loadWebPage(with: urlString)
    }
}
