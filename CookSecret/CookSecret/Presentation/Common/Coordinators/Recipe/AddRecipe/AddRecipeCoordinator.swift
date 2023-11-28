//
//  AddRecipeCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

// MARK: - Protocol

protocol AddRecipeCoordinatorProtocol: BaseCoordinatorProtocol {
    func addIngredient(delegate: AddIngredientDelegate)
}

// MARK: - Coodinator

class AddRecipeCoordinator: BaseCoordinator,
                            AddRecipeCoordinatorProtocol {
    
    // MARK: - Properties
    
    @Published var addRecipeViewModel: AddRecipeViewModel?
    @Published var addIngredientNavigationItem: NavigationItem<AddIngredientViewModel> = .init()
    
    // MARK: - Init
    
    override init() {
        super.init()
        addRecipeViewModel = DependencyInjector.getAddRecipeViewModel(coordinator: self)
    }
    
    // MARK: - AddRecipeCoordinatorProtocol
    
    func addIngredient(delegate: AddIngredientDelegate) {
        addIngredientNavigationItem.navigate(to: DependencyInjector.getAddIngredientViewModel(coordinator: self,
                                                                                              delegate: delegate))
    }
}
