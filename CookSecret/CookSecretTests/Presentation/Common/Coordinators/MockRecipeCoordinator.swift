//
//  MockRecipeCoordinator.swift
//  CookSecretTests
//
//  Created by Alvaro Grimal Cabello on 18/12/23.
//

import Foundation
import XCTest
@testable import CookSecret
import CloudKit

class MockRecipeCoordinator: RecipeCoordinatorProtocol {
    
    var addRecipeExpectation: XCTestExpectation?
    var openRecipeExpectation: XCTestExpectation?
    var openExploreRecipeExpectation: XCTestExpectation?
    var openFiltersExpectation: XCTestExpectation?
    var editRecipeExpectation: XCTestExpectation?
    var shareRecipeExpectation: XCTestExpectation?
    
    var recipe: CookSecret.RecipeDomainModel?
    
    func addRecipe() {
        addRecipeExpectation?.fulfill()
    }
    
    func openRecipe(_ recipe: CookSecret.RecipeDomainModel) {
        self.recipe = recipe
        openRecipeExpectation?.fulfill()
    }
    
    func openFilters(filter: CookSecret.RecipeListFilterViewModel) {
        filter.checkFavourites = true
        filter.type = .dessert
        filter.finishRangeTime = 23 * 3600
        filter.ingredients.append("ingredient")
        openFiltersExpectation?.fulfill()
        filter.apply()
    }
    
    func editRecipe(_ recipe: CookSecret.RecipeDomainModel, delegate: CookSecret.EditRecipeDelegate) {
        editRecipeExpectation?.fulfill()
    }
    
    func shareRecipe(share: CKShare, recipe: CookSecret.Recipe) {
        shareRecipeExpectation?.fulfill()
    }
    
    func openRecipe(_ exploreRecipe: CookSecret.ExploreMealSummaryDomainModel) {
        openExploreRecipeExpectation?.fulfill()
    }
}
