//
//  MockURLSessionRepository.swift
//  CookSecretTests
//
//  Created by Alvaro Grimal Cabello on 18/12/23.
//

import Foundation
@testable import CookSecret

class MockURLSessionRepository: HttpRepository {
    
    enum ResponseType {
        case failure
        case success
    }
    
    var response: ResponseType = .success
    
    init(response: ResponseType = .success) {
        self.response = response
    }
    
    // MARK: - HttpRepository
    
    func searchIngredient(by text: String) async throws -> [String] {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return ["Ingredient1", "Ingredient2", "Ingredient3"]
        }
    }
    
    func getExploreCategories() async throws -> [CookSecret.ExploreCategoryDomainModel] {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return [
                .init(id: "TEST1", value: "CATEGORY1"),
                .init(id: "TEST2", value: "CATEGORY2"),
                .init(id: "TEST3", value: "CATEGORY3")
            ]
        }
    }
    
    func getExploreMeals(by filter: CookSecret.ExploreMealsRequestDomainModel) async throws -> [CookSecret.ExploreMealSummaryDomainModel] {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return [
                .init(id: "TEST1", name: "NAME1", thumbnail: nil),
                .init(id: "TEST2", name: "NAME2", thumbnail: nil),
                .init(id: "TEST3", name: "NAME3", thumbnail: nil)
            ]
        }
    }
    
    func getExploreMeal(by id: String) async throws -> CookSecret.RecipeDomainModel? {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return .init(title: "title",
                         description: "description",
                         people: 1,
                         preparation: "preparation",
                         dateUpdated: .now,
                         time: 1,
                         isCustom: true,
                         ingredients: [.init(name: "INGREDIENT1",
                                             quantity: "QUANTITY1")],
                         extraInfo: [],
                         resources: [])
        }
    }
}
