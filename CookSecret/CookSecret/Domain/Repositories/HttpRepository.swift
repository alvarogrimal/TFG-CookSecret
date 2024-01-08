//
//  HttpRepository.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

protocol HttpRepository {
    func searchIngredient(by text: String) async throws -> [String]
    func getExploreCategories() async throws -> [ExploreCategoryDomainModel]
    func getExploreMeals(by filter: ExploreMealsRequestDomainModel) async throws -> [ExploreMealSummaryDomainModel]
    func getExploreMeal(by id: String) async throws -> RecipeDomainModel?
}
