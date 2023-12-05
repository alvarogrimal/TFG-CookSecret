//
//  DatabaseRepository.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import Foundation

protocol DatabaseRepository {
    // Recipes
    func getRecipes() async throws -> [RecipeDomainModel]
    func getRecipe(by id: String) async throws -> RecipeDomainModel
    func addRecipe(_ recipe: RecipeDomainModel) async throws
    func deleteRecipe(with id: String) async throws
    func editRecipe(_ recipe: RecipeDomainModel) async throws
    func setFavorite(request: RecipeFavoriteRequestDomainModel) async throws
    // Shopping list
    func getShoppingList() async throws -> ShoppingListDomainModel
    func setCompletedValue(at id: String, value: Bool) async throws
    func addShoppingListItem(_ item: ShoppingListItemDomainModel) async throws
    func deleteShoppingListItem(_ id: String) async throws
}
