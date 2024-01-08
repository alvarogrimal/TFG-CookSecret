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
    
    func getExploreCategories() async throws -> [ExploreCategoryDomainModel] {
        guard let urlRequest = TheMealDBApi.getCategories.urlRequest else {
            fatalError("Error getExploreCategories")
        }
        
        let (data, _) = try await session.data(for: urlRequest)
        let decoder = JSONDecoder()
        let dataModel = try decoder.decode(ExploreCategoryListDataModel.self, from: data)
        return dataModel.parseToDomain()
    }
    
    func getExploreMeals(by filter: ExploreMealsRequestDomainModel) async throws -> [ExploreMealSummaryDomainModel] {
        let param = URLParam(key: filter.filterType == .category ? .exploreCategory : .exploreIngredient,
                             value: filter.value)
        let parameters: [URLParam] = [param]
        
        guard let urlRequest = TheMealDBApi.getMealsBy(urlParameters: parameters).urlRequest else {
            fatalError("Error getExploreMeals")
        }
        
        let (data, _) = try await session.data(for: urlRequest)
        let decoder = JSONDecoder()
        let dataModel = try decoder.decode(ExploreMealSummaryListDataModel.self, from: data)
        return dataModel.parseToDomain()
    }
    
    func getExploreMeal(by id: String) async throws -> RecipeDomainModel? {
        let param = URLParam(key: .exploreIngredient,
                             value: id)
        let parameters: [URLParam] = [param]
        
        guard let urlRequest = TheMealDBApi.getMeal(urlParameters: parameters).urlRequest else {
            fatalError("Error getExploreMeal")
        }
        
        let (data, _) = try await session.data(for: urlRequest)
        let decoder = JSONDecoder()
        let dataModel = try decoder.decode(ExploreMealDetailDataModel.self, from: data)
        return dataModel.parseToDomain()
    }
}
