//
//  NewsSourcesInteractor.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import Foundation

class NewsSourcesInteractor: NewsSourcesInteractorInputProtocol {
    weak var presenter: NewsSourcesInteractorOutputProtocol?

    func fetchSources(withCategory category: String) {
        Task {
            do {
                let response: SourceResponse = try await APIService.shared.request(
                    endpoint: "top-headlines/sources",
                    parameters: ["category": category]
                )

                let sources = Self.uniqueSources(from: response.sources)

                await MainActor.run {
                    self.presenter?.didFetchSourcesSuccessfully(sources)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didFetchSourcesFailed(error)
                }
            }
        }
    }

    private static func uniqueSources(from sources: [NewsSource]) -> [NewsSource] {
        var seenIds = Set<String>()
        return sources.compactMap { source -> NewsSource? in
            guard seenIds.insert(source.id).inserted else { return nil }
            return source
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
