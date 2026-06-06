//
//  SourceResponse.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import Foundation

struct SourceResponse: Decodable {
    let status: String
    let sources: [NewsSource]
}

struct NewsSource: Decodable {
    let id: String
    let name: String
    let category: String
}
