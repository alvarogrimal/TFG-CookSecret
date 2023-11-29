//
//  DependencyInjector.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/11/23.
//

import Foundation

class DependencyInjector {
    
    // MARK: - Repositories
    
    static func getHttpRepository() -> HttpRepository {
        URLSessionRepository.shared()
    }
    
    static func getDatabaseRepository() -> DatabaseRepository {
        CoreDataRepository.shared()
    }
    
    // MARK: - UseCases
    
    static func searchIngredientUseCase() -> SearchIngredientUseCase {
        .init(httpRepository: getHttpRepository())
    }
    
    static func addRecipeUseCase() -> AddRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func getRecipesUseCase() -> GetRecipesUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    // MARK: - ViewModels
    
    static func getRecipeListViewModel(coordinator: RecipeCoordinatorProtocol) -> RecipeListViewModel {
        .init(getRecipesUseCase: getRecipesUseCase(),
              coordinator: coordinator)
    }
    
    static func getAddRecipeViewModel(coordinator: AddRecipeCoordinator) -> AddRecipeViewModel {
        .init(addRecipeUseCase: addRecipeUseCase(),
              coordinator: coordinator)
    }
    
    static func getAddIngredientViewModel(coordinator: AddRecipeCoordinator,
                                          delegate: AddIngredientDelegate) -> AddIngredientViewModel {
        .init(coordinator: coordinator,
              searchIngredientUseCase: searchIngredientUseCase(),
              delegate: delegate)
    }
    
    static func getRecipeDetailViewModel(recipe: RecipeDomainModel,
                                         coordinator: RecipeCoordinatorProtocol) -> RecipeDetailViewModel {
        .init(recipeDomainModel: recipe,
              coordinator: coordinator)
    }
}
