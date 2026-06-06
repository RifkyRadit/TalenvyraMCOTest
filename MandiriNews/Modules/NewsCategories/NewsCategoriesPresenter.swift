//
//  NewsCategoriesPresenter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 03/06/26.
//

import Foundation

class NewsCategoriesPresenter: NewsCategoriesPresenterProtocol {
    weak var view: NewsCategoriesViewProtocol?
    
    var interactor: NewsCategoriesInteractorInputProtocol?
    var router: NewsCategoriesRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchCategories()
    }
    
    func didSelectedCategory(_ category: String) {
        router?.navigateToSources(from: view, withCategory: category)
    }
}

extension NewsCategoriesPresenter: NewsCategoriesInteractorOutputProtocol {
    func didFetchCategorySuccessfully(_ categories: [String]) {
        view?.hideLoading()
        if categories.isEmpty {
            view?.showErrorState(.noData)
        } else {
            view?.showCategories(categories)
        }
    }
    
    func didFetchCategoryFailed(_ error: any Error) {
        view?.hideLoading()
        
        if let networkError = error as? NetworkError {
            view?.showErrorState(networkError)
        } else {
            view?.showErrorState(.invalidURL)
        }
    }
}
