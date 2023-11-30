//
//  RecipeCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import Foundation

// MARK: - Protocol

protocol RecipeCoordinatorProtocol: BaseCoordinatorProtocol {
    func addRecipe()
    func openRecipe(_ recipe: RecipeDomainModel)
    func openFilters(filter: RecipeListFilterViewModel)
}

// MARK: - Coodinator

final class RecipeCoordinator: BaseCoordinator,
                               RecipeCoordinatorProtocol {
    
    // MARK: - Properties
    
    @Published var recipeListViewModel: RecipeListViewModel?
    @Published var addRecipeNavigationItem: NavigationItem<AddRecipeCoordinator> = .init()
    @Published var recipeDetailItem: NavigationItem<RecipeDetailViewModel> = .init()
    @Published var filtersItem: NavigationItem<RecipeListFilterViewModel> = .init()
    
    // MARK: - Init
    
    override init() {
        super.init()
        recipeListViewModel = DependencyInjector.getRecipeListViewModel(coordinator: self)
    }
    
    // MARK: - RecipeCoordinatorProtocol
    
    func addRecipe() {
        addRecipeNavigationItem.navigate(to: .init())
    }
    
    func openRecipe(_ recipe: RecipeDomainModel) {
        recipeDetailItem.navigate(to: DependencyInjector
            .getRecipeDetailViewModel(recipe: recipe,
                                      coordinator: self))
    }
    
    func openFilters(filter: RecipeListFilterViewModel) {
        filtersItem.navigate(to: filter)
    }
}

// MARK: - Mock

extension RecipeCoordinator {
    static let sample: RecipeCoordinator = {
        .init()
    }()
}
