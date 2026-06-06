//
//  NewsArticlesEntity.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import Foundation

struct ArticlesResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleData]
}

struct ArticleData: Decodable {
    let source: ArticleSource
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct ArticleSource: Decodable {
    let id: String?
    let name: String
}
