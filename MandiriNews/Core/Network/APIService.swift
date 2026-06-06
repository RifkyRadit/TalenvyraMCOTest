//
//  APIService.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 03/06/26.
//

import Alamofire
import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
}

class APIService {
    static let shared = APIService()
    private init() { }
    
    private let apiKey = "bec0a8896e9f4c0bab69772217e5cc8a"
    private let baseUrl = "https://newsapi.org/v2/"
    
    func request<T: Decodable>(endpoint: String, parameters: Parameters = [:]) async throws -> T {
        let urlString = "\(baseUrl)\(endpoint)"
        
        var allParams = parameters
        allParams["apiKey"] = apiKey
        
        let dataTask = AF.request(urlString, method: .get, parameters: allParams)
            .serializingDecodable(T.self)
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
