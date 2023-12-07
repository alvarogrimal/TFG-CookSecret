//
//  ShoppingListCoodinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

// MARK: - Protocol

protocol ShoppingListCoodinatorProtocol: BaseCoordinatorProtocol {
    func addIngredient(delegate: AddIngredientDelegate)
    func addFromRecipes(delegate: RecipeListPickerDelegate)
}

// MARK: - Coodinator

final class ShoppingListCoodinator: BaseCoordinator,
                                    ShoppingListCoodinatorProtocol {
    
    // MARK: - Properties
    
    @Published var shoppingListViewModel: ShoppingListViewModel?
    @Published var addIngredientNavigationItem: NavigationItem<AddIngredientViewModel> = .init()
    @Published var addFromRecipesNavigationItem: NavigationItem<RecipeListPickerViewModel> = .init()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        self.shoppingListViewModel = DependencyInjector.shoppingListViewModel(coordinator: self)
    }
    
    // MARK: - ShoppingListCoordinatorProtocol
    
    func addIngredient(delegate: AddIngredientDelegate) {
        addIngredientNavigationItem.navigate(to: DependencyInjector.getAddIngredientViewModel(coordinator: self,
                                                                                              delegate: delegate))
    }
    
    func addFromRecipes(delegate: RecipeListPickerDelegate) {
        addFromRecipesNavigationItem.navigate(
            to: DependencyInjector.recipeListPickerViewModel(delegate: delegate,
                                                             coordinator: self))
    }
}

extension ShoppingListCoodinator {
    static let sample: ShoppingListCoodinator = {
        .init()
    }()
}
