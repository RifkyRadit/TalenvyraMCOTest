//
//  NewsCategoriesRouter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 03/06/26.
//

import UIKit

class NewsCategoriesRouter: NewsCategoriesRouterProtocol {
    static func createModuleNewsCategories() -> UIViewController {
        let view = NewsCategoriesViewController()
        let presenter: NewsCategoriesPresenterProtocol & NewsCategoriesInteractorOutputProtocol = NewsCategoriesPresenter()
        
        let interactor: NewsCategoriesInteractorInputProtocol = NewsCategoriesInteractor()
        let router: NewsCategoriesRouterProtocol = NewsCategoriesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToSources(from view: NewsCategoriesViewProtocol?, withCategory category: String) {
        guard let newsCategoriesVC = view as? UIViewController else { return }
        
        let newSourcesVC = NewsSourcesRouter.createModuleNewsSources(withCategory: category)
        newsCategoriesVC.navigationController?.pushViewController(newSourcesVC, animated: true)
    }
}
