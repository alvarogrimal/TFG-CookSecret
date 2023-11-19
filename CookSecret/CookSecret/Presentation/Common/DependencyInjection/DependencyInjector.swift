//
//  DependencyInjector.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/11/23.
//

import Foundation

class DependencyInjector {
    
    // MARK: - Repositories
    
    // MARK: - UseCases
    
    // MARK: - ViewModels
    
    static func getRecipeListViewModel(coordinator: RecipeCoordinatorProtocol) -> RecipeListViewModel {
        .init(coordinator: coordinator)
    }
}
