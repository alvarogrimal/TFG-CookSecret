//
//  URLSessionRepository.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

final class URLSessionRepository: NSObject,
                                  HttpRepository {
    
    // MARK: - Properties
    
    private static var repositoryInstance: URLSessionRepository?
    let session: URLSession
    
    // MARK: - Singleton
    
    static func shared() -> HttpRepository {
        if let repositoryInstance = URLSessionRepository.repositoryInstance {
            return repositoryInstance
        } else {
            URLSessionRepository.repositoryInstance = URLSessionRepository()
            return URLSessionRepository.repositoryInstance!
        }
    }
    
    private override init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        session = URLSession(configuration: sessionConfig)
        super.init()
    }
    
    // MARK: - HttpRepository
    
    func searchIngredient(by text: String) async throws -> [String] {
        let parameters: [URLParam] = [.init(key: .searchTerms, value: text),
                                      .init(key: .searchSimple, value: "0"),
                                      .init(key: .json, value: "1")]
        guard let urlRequest = OpenFoodFactsApi.searchByProduct(urlParameters: parameters).urlRequest else {
            fatalError("Error searchIngredient")
        }
        
        let (data, _) = try await session.data(for: urlRequest)
        let decoder = JSONDecoder()
        let dataModel = try decoder.decode(SearchIngredientDataModel.self, from: data)
        return dataModel.parseToDomain()
    }
}
