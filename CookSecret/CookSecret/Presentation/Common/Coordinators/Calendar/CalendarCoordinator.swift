//
//  CalendarCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

// MARK: - Protocol

protocol CalendarCoordinatorProtocol: BaseCoordinatorProtocol {
    func openRecipesPicker(delegate: RecipeListPickerDelegate?)
}

// MARK: - Coordinator

final class CalendarCoordinator: BaseCoordinator,
                                 CalendarCoordinatorProtocol {

    // MARK: - Properties
    
    @Published var calendarViewModel: CalendarViewModel?
    @Published var addRecipesNavigationItem: NavigationItem<RecipeListPickerViewModel> = .init()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        calendarViewModel = DependencyInjector.calendarViewModel(coordinator: self)
    }
    
    // MARK: - CalendarCoordinatorProtocol
    
    func openRecipesPicker(delegate: RecipeListPickerDelegate?) {
        addRecipesNavigationItem.navigate(to: DependencyInjector
            .recipeListPickerViewModel(delegate: delegate,
                                       coordinator: self))
    }
}

// MARK: - Mock

extension CalendarCoordinator {
    static let sample: CalendarCoordinator = {
        .init()
    }()
}
