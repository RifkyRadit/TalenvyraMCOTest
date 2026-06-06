//
//  NewsCategoriesInteractor.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 03/06/26.
//

import Foundation

class NewsCategoriesInteractor: NewsCategoriesInteractorInputProtocol {
    weak var presenter: NewsCategoriesInteractorOutputProtocol?
    
    func fetchCategories() {
        Task {
            do {
                let response: SourceResponse = try await APIService.shared.request(endpoint: "top-headlines/sources")
                
                let allCategories = response.sources.map{ $0.category }
                let uniqueCategories = Array(Set(allCategories).sorted())
                
                await MainActor.run {
                    self.presenter?.didFetchCategorySuccessfully(uniqueCategories)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didFetchCategoryFailed(error)
                }
            }
        }
    }
}
