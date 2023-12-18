//
//  MockDependencyInjector.swift
//  CookSecretTests
//
//  Created by Alvaro Grimal Cabello on 18/12/23.
//

import Foundation
@testable import CookSecret

class MockDependencyInjector {
    
    // MARK: - Repositories
    
    static func getHttpRepository(response: MockURLSessionRepository.ResponseType) -> HttpRepository {
        MockURLSessionRepository(response: response)
    }
    
    static func getDatabaseRepository(response: MockCoreDataRepository.ResponseType) -> DatabaseRepository {
        MockCoreDataRepository(response: response)
    }
    
    // MARK: - UseCases
    
    static func searchIngredientUseCase(response: MockURLSessionRepository.ResponseType) -> SearchIngredientUseCase {
        .init(httpRepository: getHttpRepository(response: response))
    }
    
    static func addRecipeUseCase(response: MockCoreDataRepository.ResponseType) -> AddRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func editRecipeUseCase(response: MockCoreDataRepository.ResponseType) -> EditRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func getRecipesUseCase(response: MockCoreDataRepository.ResponseType) -> GetRecipesUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func getRecipeUseCase(response: MockCoreDataRepository.ResponseType) -> GetRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func setRecipeFavoriteUseCase(response: MockCoreDataRepository.ResponseType) -> SetRecipeFavouriteUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func deleteRecipeUseCase(response: MockCoreDataRepository.ResponseType) -> DeleteRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func getExploreCategoriesUseCase(response: MockURLSessionRepository.ResponseType) -> GetExploreCategoriesUseCase {
        .init(httpRepository: getHttpRepository(response: response))
    }
    
    static func getExploreMealsUseCase(response: MockURLSessionRepository.ResponseType) -> GetExploreMealsUseCase {
        .init(httpRepository: getHttpRepository(response: response))
    }
    
    static func getExploreMealDetailUseCase(response: MockURLSessionRepository.ResponseType) -> GetExploreMealDetailUseCase {
        .init(httpRepository: getHttpRepository(response: response))
    }
    
    static func getShoppingListUseCase(response: MockCoreDataRepository.ResponseType) -> GetShoppingListUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func addShoppingListItemUseCase(response: MockCoreDataRepository.ResponseType) -> AddShoppingListItemUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func deleteShoppingListItemUseCase(response: MockCoreDataRepository.ResponseType) -> DeleteShoppingListItemUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func setCompleteShoppingListItemUseCase(response: MockCoreDataRepository.ResponseType) -> SetCompleteShoppingListItemUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func getPlanningUseCase(response: MockCoreDataRepository.ResponseType) -> GetPlanningUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func deletePlannedRecipeUseCase(response: MockCoreDataRepository.ResponseType) -> DeletePlannedRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
    
    static func setPlannedRecipesUseCase(response: MockCoreDataRepository.ResponseType) -> SetPlannedRecipesUseCase {
        .init(databaseRepository: getDatabaseRepository(response: response))
    }
}
