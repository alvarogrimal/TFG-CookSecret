//
//  MockCoreDataRepository.swift
//  CookSecretTests
//
//  Created by Alvaro Grimal Cabello on 18/12/23.
//

import Foundation
@testable import CookSecret

class MockCoreDataRepository: DatabaseRepository {
    
    enum ResponseType {
        case failure
        case success
    }
    
    var response: ResponseType = .success
    
    init(response: ResponseType = .success) {
        self.response = response
    }
    
    // MARK: - DatabaseRepository
    
    func getRecipes() async throws -> [CookSecret.RecipeDomainModel] {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return [.init(title: "title",
                          description: "description",
                          people: 1,
                          preparation: "preparation",
                          dateUpdated: .now,
                          time: 1,
                          isCustom: true,
                          ingredients: [.init(name: "INGREDIENT1",
                                              quantity: "QUANTITY1")],
                          extraInfo: [],
                          resources: [])]
        }
    }
    
    func getRecipe(by id: String) async throws -> CookSecret.RecipeDomainModel {
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
    
    func addRecipe(_ recipe: CookSecret.RecipeDomainModel) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func deleteRecipe(with id: String) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func editRecipe(_ recipe: CookSecret.RecipeDomainModel) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func setFavorite(request: CookSecret.RecipeFavoriteRequestDomainModel) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func getShoppingList() async throws -> CookSecret.ShoppingListDomainModel {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return .init(list: [.init(ingredient: .init(name: "INGREDIENT1",
                                                        quantity: "QUANTITY1")),
                                .init(ingredient: .init(name: "INGREDIENT2",
                                                        quantity: "QUANTITY2"))])
        }
    }
    
    func setCompletedValue(at id: String, value: Bool) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func addShoppingListItem(_ item: CookSecret.ShoppingListItemDomainModel) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func deleteShoppingListItem(_ id: String) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func getPlanning() async throws -> [CookSecret.PlanningItemDomainModel] {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return [
                .init(date: .now,
                      recipes: [.init(title: "title",
                                      description: "description",
                                      people: 1,
                                      preparation: "preparation",
                                      dateUpdated: .now,
                                      time: 1,
                                      isCustom: true,
                                      ingredients: [.init(name: "INGREDIENT1",
                                                          quantity: "QUANTITY1")],
                                      extraInfo: [],
                                      resources: [])])
            ]
        }
    }
    
    func setRecipes(_ recipes: [CookSecret.RecipeDomainModel], at date: Date) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
    
    func deleteRecipe(_ recipeId: String, at date: Date) async throws {
        switch response {
        case .failure:
            throw NSError()
        case .success:
            return
        }
    }
}
