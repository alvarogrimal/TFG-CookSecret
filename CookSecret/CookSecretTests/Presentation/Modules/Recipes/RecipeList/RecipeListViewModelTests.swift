//
//  RecipeListViewModelTests.swift
//  CookSecretTests
//
//  Created by Alvaro Grimal Cabello on 18/12/23.
//

import Foundation
import XCTest
@testable import CookSecret

final class RecipeListViewModelTests: XCTestCase {
    
    func testOnLoad() {
        // Given
        let sut = sut()
        
        // When
        let recipeListExpectation = XCTestExpectation(description: "recipeListExpectation")
        sut.$recipeList
            .sink { list in
                !list.isEmpty ? recipeListExpectation.fulfill() : nil
            }
            .store(in: &sut.cancellableSet)
        sut.onLoad()
        
        // Then
        wait(for: [recipeListExpectation], timeout: 5)
        XCTAssertEqual(sut.recipeList.count, 1)
        XCTAssertEqual(sut.recipeList.first?.title, "title")
    }
    
    func testAddRecipeTapped() {
        // Given
        let coodinator = MockRecipeCoordinator()
        let sut = sut(coodinator: coodinator)
        
        // When
        coodinator.addRecipeExpectation = XCTestExpectation(description: "addRecipeExpectation")
        sut.addRecipeTapped()
        
        // Then
        wait(for: [coodinator.addRecipeExpectation!], timeout: 5)
    }
    
    func testOpenRecipe() {
        // Given
        let coodinator = MockRecipeCoordinator()
        let sut = sut(coodinator: coodinator)
        let recipeListExpectation = XCTestExpectation(description: "recipeListExpectation")
        sut.$recipeList
            .sink { list in
                !list.isEmpty ? recipeListExpectation.fulfill() : nil
            }
            .store(in: &sut.cancellableSet)
        sut.onLoad()
        wait(for: [recipeListExpectation], timeout: 5)
        
        // When
        coodinator.openRecipeExpectation = XCTestExpectation(description: "openRecipeExpectation")
        sut.openRecipe(id: sut.recipeList.first!.id)
        
        // Then
        wait(for: [coodinator.openRecipeExpectation!], timeout: 5)
        XCTAssertEqual(coodinator.recipe?.title, "title")
    }
    
    func testOpenFilters() {
        // Given
        let coodinator = MockRecipeCoordinator()
        let sut = sut(coodinator: coodinator)
        let recipeListExpectation = XCTestExpectation(description: "recipeListExpectation")
        sut.$recipeList
            .sink { list in
                !list.isEmpty ? recipeListExpectation.fulfill() : nil
            }
            .store(in: &sut.cancellableSet)
        sut.onLoad()
        wait(for: [recipeListExpectation], timeout: 5)
        
        // When
        coodinator.openFiltersExpectation = XCTestExpectation(description: "openFiltersExpectation")
        sut.openFilters()
        
        // Then
        wait(for: [coodinator.openFiltersExpectation!], timeout: 5)
    }
    
    func testSearchEmpty() {
        // Given
        let coodinator = MockRecipeCoordinator()
        let sut = sut(coodinator: coodinator)
        let recipeListExpectation = XCTestExpectation(description: "recipeListExpectation")
        let searchExpectation = XCTestExpectation(description: "searchExpectation")
        var countSetList = 0
        sut.$recipeList
            .sink { list in
                switch countSetList {
                case 0:
                    if !list.isEmpty {
                        countSetList += 1
                        recipeListExpectation.fulfill()
                    }
                case 1:
                    countSetList += 1
                    searchExpectation.fulfill()
                default: break
                }
            }
            .store(in: &sut.cancellableSet)
        sut.onLoad()
        wait(for: [recipeListExpectation], timeout: 5)
        
        // When
        sut.searchText = "test"
        wait(for: [searchExpectation], timeout: 5)
        
        // Then
        XCTAssertEqual(sut.recipeList.count, 0)
    }
    
    func testSearchSuccess() {
        // Given
        let coodinator = MockRecipeCoordinator()
        let sut = sut(coodinator: coodinator)
        let recipeListExpectation = XCTestExpectation(description: "recipeListExpectation")
        let searchExpectation = XCTestExpectation(description: "searchExpectation")
        var countSetList = 0
        sut.$recipeList
            .sink { list in
                switch countSetList {
                case 0:
                    if !list.isEmpty {
                        countSetList += 1
                        recipeListExpectation.fulfill()
                    }
                case 1:
                    countSetList += 1
                    searchExpectation.fulfill()
                default: break
                }
            }
            .store(in: &sut.cancellableSet)
        sut.onLoad()
        wait(for: [recipeListExpectation], timeout: 5)
        
        // When
        sut.searchText = "title"
        wait(for: [searchExpectation], timeout: 5)
        
        // Then
        XCTAssertEqual(sut.recipeList.count, 1)
    }
    
    func testApplyFilter() {
        // Given
        let coodinator = MockRecipeCoordinator()
        let sut = sut(coodinator: coodinator)
        let recipeListExpectation = XCTestExpectation(description: "recipeListExpectation")
        let filteredExpectation = XCTestExpectation(description: "filteredExpectation")
        var countSetList = 0
        sut.$recipeList
            .sink { list in
                switch countSetList {
                case 0:
                    if !list.isEmpty {
                        countSetList += 1
                        recipeListExpectation.fulfill()
                    }
                case 1:
                    countSetList += 1
                    filteredExpectation.fulfill()
                default: break
                }
            }
            .store(in: &sut.cancellableSet)
        sut.onLoad()
        wait(for: [recipeListExpectation], timeout: 5)
        
        // When
        coodinator.openFiltersExpectation = XCTestExpectation(description: "openFiltersExpectation")
        sut.openFilters()
        
        // Then
        wait(for: [coodinator.openFiltersExpectation!,
                   filteredExpectation],
             timeout: 5,
             enforceOrder: true)
        XCTAssertEqual(sut.recipeList.count, 0)
    }
}

extension RecipeListViewModelTests {
    func sut(coodinator: MockRecipeCoordinator = .init(),
             response: MockCoreDataRepository.ResponseType = .success) -> RecipeListViewModel {
        .init(getRecipesUseCase: MockDependencyInjector.getRecipesUseCase(response: response),
              coordinator: coodinator)
    }
}
