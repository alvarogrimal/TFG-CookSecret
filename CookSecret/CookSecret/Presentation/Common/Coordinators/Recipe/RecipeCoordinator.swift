//
//  RecipeCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import Foundation
import CoreData
import CloudKit

// MARK: - Protocol

protocol RecipeCoordinatorProtocol: ExploreRecipeDetailCoordinatorProtocol {
    func addRecipe()
    func openRecipe(_ recipe: RecipeDomainModel)
    func openFilters(filter: RecipeListFilterViewModel)
    func editRecipe(_ recipe: RecipeDomainModel,
                    delegate: EditRecipeDelegate)
}

// MARK: - Coodinator

final class RecipeCoordinator: BaseCoordinator,
                               RecipeCoordinatorProtocol {
    
    // MARK: - Properties
    
    @Published var recipeListViewModel: RecipeListViewModel?
    @Published var addRecipeNavigationItem: NavigationItem<AddRecipeCoordinator> = .init()
    @Published var recipeDetailItem: NavigationItem<RecipeDetailViewModel> = .init()
    @Published var exploreRecipeDetailItem: NavigationItem<ExploreRecipeDetailViewModel> = .init()
    @Published var filtersItem: NavigationItem<RecipeListFilterViewModel> = .init()
    @Published var editRecipeNavigationItem: NavigationItem<AddRecipeCoordinator> = .init()
    
    // MARK: - Init
    
    override init() {
        super.init()
        recipeListViewModel = DependencyInjector.getRecipeListViewModel(coordinator: self)
    }
    
    // MARK: - RecipeCoordinatorProtocol
    
    func addRecipe() {
        addRecipeNavigationItem.navigate(to: .init(type: .add))
    }
    
    func openRecipe(_ recipe: RecipeDomainModel) {
        if !recipe.isCustom {
            exploreRecipeDetailItem.navigate(to: DependencyInjector
                .getExploreRecipeDetailViewModel(exploreRecipeDetail: recipe,
                                                 coordinator: self))
        } else {
            recipeDetailItem.navigate(to: DependencyInjector
                .getRecipeDetailViewModel(recipe: recipe,
                                          coordinator: self))
        }
    }
    
    func openFilters(filter: RecipeListFilterViewModel) {
        filtersItem.navigate(to: filter)
    }
    
    func editRecipe(_ recipe: RecipeDomainModel,
                    delegate: EditRecipeDelegate) {
        editRecipeNavigationItem.navigate(to: .init(type: .edit(domainModel: recipe,
                                                                delegate: delegate)))
    }
    
    func openRecipe(_ exploreRecipe: ExploreMealSummaryDomainModel) {}

}

// MARK: - Mock

extension RecipeCoordinator {
    static let sample: RecipeCoordinator = {
        .init()
    }()
}
