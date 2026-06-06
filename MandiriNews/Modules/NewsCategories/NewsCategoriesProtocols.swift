//
//  NewsCategoriesProtocols.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 03/06/26.
//

import UIKit

protocol NewsCategoriesViewProtocol: AnyObject {
    var presenter: NewsCategoriesPresenterProtocol? { get set }
    func showCategories(_ categories: [String])
    func showErrorState(_ message: NetworkError)
    func showLoading()
    func hideLoading()
}

protocol NewsCategoriesPresenterProtocol: AnyObject {
    var view: NewsCategoriesViewProtocol? { get set }
    var interactor: NewsCategoriesInteractorInputProtocol? { get set }
    var router: NewsCategoriesRouterProtocol? { get set }
    
    func viewDidLoad()
    func didSelectedCategory(_ category: String)
}

protocol NewsCategoriesInteractorInputProtocol: AnyObject {
    var presenter: NewsCategoriesInteractorOutputProtocol? { get set }
    func fetchCategories()
}

protocol NewsCategoriesInteractorOutputProtocol: AnyObject {
    func didFetchCategorySuccessfully(_ categories: [String])
    func didFetchCategoryFailed(_ error: Error)
}

protocol NewsCategoriesRouterProtocol: AnyObject {
    static func createModuleNewsCategories() -> UIViewController
    func navigateToSources(from view: NewsCategoriesViewProtocol?, withCategory category: String)
}
