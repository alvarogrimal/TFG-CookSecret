//
//  TabbarCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import Foundation

// MARK: - Protocol

protocol TabbarCoordinatorProtocol: BaseCoordinatorProtocol {
}

// MARK: - Coodinator

final class TabbarCoordinator: BaseCoordinator, TabbarCoordinatorProtocol {
    
    // MARK: - Properties
    
    var recipeCoordinator: RecipeCoordinator
    var exploreCoordinator: ExploreCoordinator
    var shoppingListCoodinator: ShoppingListCoodinator
    var calendarCoordinator: CalendarCoordinator
    
    override init() {
        recipeCoordinator = .sample
        exploreCoordinator = .sample
        shoppingListCoodinator = .sample
        calendarCoordinator = .sample
    }
    
    // MARK: - TabbarCoordinatorProtocol
    
}

// MARK: - Mock

extension TabbarCoordinator {
    static let sample: TabbarCoordinator = {
        .init()
    }()
}
