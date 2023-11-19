//
//  RecipeCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import Foundation

// MARK: - Protocol

protocol RecipeCoordinatorProtocol: BaseCoordinatorProtocol {
}

// MARK: - Coodinator

final class RecipeCoordinator: BaseCoordinator,
                               RecipeCoordinatorProtocol {
    
    // MARK: - Properties
    
    @Published var viewModel: RecipeListViewModel?
    
    // MARK: - Init
    
    override init() {
        super.init()
        self.viewModel = DependencyInjector.getRecipeListViewModel(coordinator: self)
    }
    
    // MARK: - RecipeCoordinatorProtocol
    
}

// MARK: - Mock

extension RecipeCoordinator {
    static let sample: RecipeCoordinator = {
        .init()
    }()
}
