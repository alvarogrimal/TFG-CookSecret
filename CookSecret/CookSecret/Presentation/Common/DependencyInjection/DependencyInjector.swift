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
        if CommandLine.arguments.contains("testing") {
            return MockURLSessionRepository(response: .success)
        } else {
            return URLSessionRepository.shared()
        }
    }
    
    static func getDatabaseRepository() -> DatabaseRepository {
        if CommandLine.arguments.contains("testing") {
            if CommandLine.arguments.contains("successEmpty") {
                return MockCoreDataRepository(response: .successEmpty)
            } else {
                return MockCoreDataRepository(response: .success)
            }
        } else {
            return CoreDataRepository.shared()
        }
    }
    
    // MARK: - UseCases
    
    static func searchIngredientUseCase() -> SearchIngredientUseCase {
        .init(httpRepository: getHttpRepository())
    }
    
    static func addRecipeUseCase() -> AddRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func editRecipeUseCase() -> EditRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func getRecipesUseCase() -> GetRecipesUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func getRecipeUseCase() -> GetRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func setRecipeFavoriteUseCase() -> SetRecipeFavouriteUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func deleteRecipeUseCase() -> DeleteRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func getExploreCategoriesUseCase() -> GetExploreCategoriesUseCase {
        .init(httpRepository: getHttpRepository())
    }
    
    static func getExploreMealsUseCase() -> GetExploreMealsUseCase {
        .init(httpRepository: getHttpRepository())
    }
    
    static func getExploreMealDetailUseCase() -> GetExploreMealDetailUseCase {
        .init(httpRepository: getHttpRepository())
    }
    
    static func getShoppingListUseCase() -> GetShoppingListUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func addShoppingListItemUseCase() -> AddShoppingListItemUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func deleteShoppingListItemUseCase() -> DeleteShoppingListItemUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func setCompleteShoppingListItemUseCase() -> SetCompleteShoppingListItemUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func getPlanningUseCase() -> GetPlanningUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func deletePlannedRecipeUseCase() -> DeletePlannedRecipeUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    static func setPlannedRecipesUseCase() -> SetPlannedRecipesUseCase {
        .init(databaseRepository: getDatabaseRepository())
    }
    
    // MARK: - ViewModels
    
    static func getRecipeListViewModel(coordinator: RecipeCoordinatorProtocol) -> RecipeListViewModel {
        .init(getRecipesUseCase: getRecipesUseCase(),
              coordinator: coordinator)
    }
    
    static func getAddRecipeViewModel(coordinator: AddRecipeCoordinator,
                                      type: AddRecipeCoordinator.AddRecipeType) -> AddRecipeViewModel {
        .init(addRecipeUseCase: addRecipeUseCase(),
              editRecipeUseCase: editRecipeUseCase(),
              type: type,
              coordinator: coordinator)
    }
    
    static func getAddIngredientViewModel(coordinator: BaseCoordinator,
                                          delegate: AddIngredientDelegate) -> AddIngredientViewModel {
        .init(coordinator: coordinator,
              searchIngredientUseCase: searchIngredientUseCase(),
              delegate: delegate)
    }
    
    static func getRecipeDetailViewModel(recipe: RecipeDomainModel,
                                         coordinator: RecipeCoordinatorProtocol) -> RecipeDetailViewModel {
        .init(recipeDomainModel: recipe, 
              setRecipeFavoriteUseCase: setRecipeFavoriteUseCase(),
              deleteRecipeUseCase: deleteRecipeUseCase(), 
              getRecipeUseCase: getRecipeUseCase(),
              coordinator: coordinator)
    }
    
    static func getRecipeListFilterViewModel(delegate: RecipeListFilterDelegate?,
                                             coordinator: RecipeCoordinatorProtocol) -> RecipeListFilterViewModel {
        .init(searchIngredientUseCase: searchIngredientUseCase(),
              delegate: delegate,
              coordinator: coordinator)
    }
    
    static func exploreViewModel(coordinator: ExploreCoordinatorProtocol) -> ExploreViewModel {
        .init(getExploreCategoriesUseCase: getExploreCategoriesUseCase(),
              getExploreMealsUseCase: getExploreMealsUseCase(),
              coordinator: coordinator)
    }
    
    static func getExploreRecipeDetailViewModel(exploreRecipe: ExploreMealSummaryDomainModel? = nil,
                                                exploreRecipeDetail: RecipeDomainModel? = nil,
                                                coordinator: ExploreRecipeDetailCoordinatorProtocol) -> ExploreRecipeDetailViewModel {
        .init(exploreRecipe: exploreRecipe,
              exploreRecipeDetail: exploreRecipeDetail,
              getExploreMealDetailUseCase: getExploreMealDetailUseCase(),
              addRecipeUseCase: addRecipeUseCase(),
              setRecipeFavoriteUseCase: setRecipeFavoriteUseCase(),
              deleteRecipeUseCase: deleteRecipeUseCase(),
              getRecipeUseCase: getRecipeUseCase(),
              coordinator: coordinator)
    }
    
    static func shoppingListViewModel(coordinator: ShoppingListCoodinatorProtocol) -> ShoppingListViewModel {
        .init(getShoppingListUseCase: getShoppingListUseCase(),
              addShoppingListItemUseCase: addShoppingListItemUseCase(),
              deleteShoppingListItemUseCase: deleteShoppingListItemUseCase(),
              setCompleteShoppingListItemUseCase: setCompleteShoppingListItemUseCase(),
              coordinator: coordinator)
    }
    
    static func recipeListPickerViewModel(delegate: RecipeListPickerDelegate?,
                                          coordinator: BaseCoordinatorProtocol) -> RecipeListPickerViewModel {
        .init(delegate: delegate,
              getRecipesUseCase: DependencyInjector.getRecipesUseCase(),
              coordinator: coordinator)
    }
    
    static func calendarViewModel(coordinator: CalendarCoordinatorProtocol) -> CalendarViewModel {
        .init(getPlanningUseCase: getPlanningUseCase(),
              deletePlannedRecipeUseCase: deletePlannedRecipeUseCase(),
              setPlannedRecipesUseCase: setPlannedRecipesUseCase(),
              coordinator: coordinator)
    }
}
