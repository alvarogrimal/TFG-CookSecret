//
//  CookSecretUITests.swift
//  CookSecretUITests
//
//  Created by Alvaro Grimal Cabello on 13/11/23.
//

import XCTest
import CookSecret
import FSCalendar

class RecipeListViewUITests: XCTestCase {
    
    enum AccesibilityKeys: String {
        case recipeListView
        case emptyRecipeImage
        case emptyRecipeText
        case recipeThumbnail
        case recipeTitle
        case recipeCell
        case filterButton
        case addRecipeButton
    }

    let app = XCUIApplication()
    
    func config(useEmpty: Bool = false) {
        continueAfterFailure = false
        let params = !useEmpty ? ["testing"] : ["testing", "successEmpty"]
        app.launchArguments = params
        app.launch()
    }

    func testEmptyRecipeView() throws {
        config(useEmpty: true)
        XCTAssertEqual(app.images[AccesibilityKeys.recipeListView.rawValue].label,
                       "Recipe")
        XCTAssertEqual(app.staticTexts[AccesibilityKeys.recipeListView.rawValue].label,
                       "You do not have any recipe yet")
    }

    func testAddRecipeButton() throws {
        config()
        let addRecipeButton = app.buttons[AccesibilityKeys.addRecipeButton.rawValue]
        XCTAssertTrue(addRecipeButton.exists)
        addRecipeButton.tap()
        sleep(1)
        XCTAssertTrue(app.navigationBars["Add recipe"].exists)
    }

    func testFilterButton() throws {
        config()
        let filterButton = app.buttons[AccesibilityKeys.filterButton.rawValue]
        XCTAssertTrue(filterButton.exists)
        filterButton.tap()
        XCTAssertTrue(app.navigationBars["Filters"].exists)
    }

    func testSearchFunctionality() throws {
        config()
        let recipeScrollView = app.scrollViews[AccesibilityKeys.recipeListView.rawValue]
        XCTAssertTrue(recipeScrollView.exists)

        let recipeCells = app.staticTexts.matching(identifier: AccesibilityKeys.recipeCell.rawValue)
        let initialCellsCount = recipeCells.count

        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("B")
        
        let updatedRecipeCells = app.staticTexts.matching(identifier: AccesibilityKeys.recipeCell.rawValue)
        XCTAssertTrue(updatedRecipeCells.count < initialCellsCount)
    }

    func testPullToRefresh() throws {
        config()
        let recipeScrollView = app.scrollViews[AccesibilityKeys.recipeListView.rawValue]
        XCTAssertTrue(recipeScrollView.exists)
        
        let recipeCells = app.staticTexts.matching(identifier: AccesibilityKeys.recipeCell.rawValue)
        let initialCellsCount = recipeCells.count
        
        let firstCell = recipeCells.firstMatch
        firstCell.press(forDuration: 0.5, thenDragTo: recipeScrollView)

        let updatedRecipeCells = app.staticTexts.matching(identifier: AccesibilityKeys.recipeCell.rawValue)
        XCTAssertTrue(updatedRecipeCells.count == initialCellsCount)
    }

    func testRecipeCellAccessibility() throws {
        config()
        let recipeCell = app.staticTexts[AccesibilityKeys.recipeCell.rawValue].firstMatch
        XCTAssertTrue(recipeCell.exists)

        XCTAssertTrue(recipeCell.identifier == AccesibilityKeys.recipeCell.rawValue)
    }

    func testRecipeDetailViewBackButton() throws {
        config()
        let recipeCell = app.staticTexts[AccesibilityKeys.recipeCell.rawValue].firstMatch
        XCTAssertTrue(recipeCell.exists)
        recipeCell.tap()

        XCTAssertTrue(app.navigationBars.buttons["My Recipes"].exists)
        app.navigationBars.buttons["My Recipes"].tap()

        XCTAssertTrue(app.scrollViews[AccesibilityKeys.recipeListView.rawValue].exists)
    }
}
