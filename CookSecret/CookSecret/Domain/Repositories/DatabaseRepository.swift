//
//  DatabaseRepository.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import Foundation

protocol DatabaseRepository {
    func getRecipes() async throws -> [RecipeDomainModel]
    func addRecipe(_ recipe: RecipeDomainModel) async throws
    func deleteRecipe(with id: String) async throws
    func editRecipe(_ recipe: RecipeDomainModel) async throws
    func setFavorite(request: RecipeFavoriteRequestDomainModel) async throws
}
