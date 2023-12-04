//
//  ExploreCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 1/12/23.
//

import Foundation

// MARK: - Protocol

protocol ExploreCoordinatorProtocol: ExploreRecipeDetailCoordinatorProtocol,
                                     BaseCoordinatorProtocol {
}

// MARK: - Coodinator

final class ExploreCoordinator: BaseCoordinator,
                                ExploreCoordinatorProtocol {
    
    // MARK: - Properties
    
    @Published var exploreViewModel: ExploreViewModel?
    @Published var exploreRecipeDetailNavigationItem: NavigationItem<ExploreRecipeDetailViewModel> = .init()
    
    override init() {
        super.init()
        self.exploreViewModel = DependencyInjector.exploreViewModel(coordinator: self)
    }
    
    func openRecipe(_ exploreRecipe: ExploreMealSummaryDomainModel) {
        let instance = DependencyInjector.getExploreRecipeDetailViewModel(
            exploreRecipe: exploreRecipe,
            coordinator: self)
        exploreRecipeDetailNavigationItem.navigate(to: instance)
    }
}

// MARK: - Mock

extension ExploreCoordinator {
    static let sample: ExploreCoordinator = {
        .init()
    }()
}
