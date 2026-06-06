//
//  ArticleDetailProtocols.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 06/06/26.
//

import UIKit

protocol ArticleDetailViewProtocol: AnyObject {
    var presenter: ArticleDetailPresenterProtocol? { get set }
    func loadWebPage(with urlString: String)
}

protocol ArticleDetailPresenterProtocol: AnyObject {
    var view: ArticleDetailViewProtocol? { get set }
    var router: ArticleDetailRouterProtocol? { get set }
    
    func viewDidLoad()
}

protocol ArticleDetailRouterProtocol: AnyObject {
    static func createModule(withUrl urlString: String) -> UIViewController
}
