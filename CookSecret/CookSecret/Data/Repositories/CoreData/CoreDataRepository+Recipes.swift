//
//  CoreDataRepository+Recipes.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import Foundation
import CoreData

extension CoreDataRepository {

    func getRecipes() async throws -> [RecipeDomainModel] {
        try await withCheckedThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            do {
                let result = try container.viewContext.fetch(fetchRequest)
                print("✅ Success: Recipe list retrieved")
                let domainList = result.compactMap { recipe in
                    parseToDomain(recipe: recipe)
                }
                continuation.resume(returning: domainList)
            } catch {
                print("❌ Error: Recipe list retrieved")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addRecipe(_ recipe: RecipeDomainModel) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            let context = container.viewContext
            
            let recipeDB = Recipe(context: context)
            recipeDB.identifier = recipe.id
            recipeDB.desc = recipe.description
            recipeDB.isFavorite = recipe.isFavorite
            recipeDB.people = Int16(recipe.people)
            recipeDB.preparation = recipe.preparation
            recipeDB.time = recipe.time
            recipeDB.timestamp = recipe.dateUpdated
            recipeDB.title = recipe.title
            recipeDB.type = recipe.type
            let extraInfo: [ExtraInfo] = recipe.extraInfo.compactMap({ value in
                let item = ExtraInfo(context: context)
                item.title = value.title
                item.desc = value.description
                return item
            })
            let ingredients: [Ingredient] = recipe.ingredients.compactMap({ value in
                let item = Ingredient(context: context)
                item.identifier = value.id
                item.title = value.name
                item.quantity = value.quantity
                return item
            })
            let resources: [Resource] = recipe.resources.compactMap({ value in
                let item = Resource(context: context)
                item.identifier = value.id
                item.image = value.image
                return item
            })
            recipeDB.extraInfoList = NSSet(array: extraInfo)
            recipeDB.ingredientList = NSSet(array: ingredients)
            recipeDB.resourceList = NSSet(array: resources)
            
            do {
                try context.save()
                print("✅ Success: Garment saved")
                continuation.resume()
            } catch {
                print("❌ Error: Garment saved \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deleteRecipe(with id: String) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            let context = container.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                for object in result where object.identifier == id {
                    context.delete(object)
                }
                try context.save()
                print("✅ Success: Garment deleted")
                continuation.resume()
            } catch {
                print("❌ Error: Garment retrieved \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func editRecipe(_ recipe: RecipeDomainModel) async throws {
        
    }
    
    func setFavorite(request: RecipeFavoriteRequestDomainModel) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            let context = container.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                guard let recipe = result.first(where: { $0.identifier == request.id }) else {
                    continuation.resume(throwing: NSError())
                    return
                }
                recipe.isFavorite = request.isFavourite
                try context.save()
                print("✅ Success: Garment deleted")
                continuation.resume()
            } catch {
                print("❌ Error: Garment retrieved \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Private functions
    
    private func parseToDomain(recipe: Recipe) -> RecipeDomainModel {
        
        let ingredients: [Ingredient] = recipe.ingredientList?
            .allObjects as? [Ingredient] ?? []
        let extraInfo: [ExtraInfo] = recipe.extraInfoList?
            .allObjects as? [ExtraInfo] ?? []
        let resources: [Resource] = recipe.resourceList?
            .allObjects as? [Resource] ?? []
        
        return RecipeDomainModel(id: recipe.identifier ?? "",
                                 title: recipe.title ?? "",
                                 type: recipe.type ?? "",
                                 description: recipe.desc ?? "",
                                 isFavorite: recipe.isFavorite,
                                 people: Int(recipe.people),
                                 preparation: recipe.preparation ?? "",
                                 dateUpdated: recipe.timestamp ?? .now,
                                 time: recipe.time,
                                 ingredients: parseIngredientsToDomain(ingredients),
                                 extraInfo: parseExtraInfoToDomain(extraInfo),
                                 resources: parseResourcesToDomain(resources))
    }
    
    private func parseIngredientsToDomain(_ ingredients: [Ingredient]) -> [IngredientDomainModel] {
        ingredients.compactMap { ingredient in
                .init(id: ingredient.identifier ?? UUID().uuidString,
                      name: ingredient.title ?? "",
                      quantity: ingredient.quantity ?? "")
        }
    }
    
    private func parseExtraInfoToDomain(_ extraInfo: [ExtraInfo]) -> [ExtraInfoDomainModel] {
        extraInfo.compactMap { item in
                .init(title: item.title ?? "",
                      description: item.desc ?? "")
        }
    }
    
    private func parseResourcesToDomain(_ resources: [Resource]) -> [ResourceDomainModel] {
        resources.compactMap { resource in
                .init(id: resource.identifier ?? UUID().uuidString,
                      image: resource.image ?? .init())
        }
    }
}
