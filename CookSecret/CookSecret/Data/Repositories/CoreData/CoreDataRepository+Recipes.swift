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
                let result = try containerRecipes.viewContext.fetch(fetchRequest)
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
    
    func getRecipe(by id: String) async throws -> RecipeDomainModel {
        return try await withCheckedThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            let context = containerRecipes.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                guard let recipeDB = result.first(where: { $0.identifier == id }) else {
                    continuation.resume(throwing: NSError())
                    return
                }
                
                print("✅ Success: Recipe retrieved")
                continuation.resume(returning: parseToDomain(recipe: recipeDB))
            } catch {
                print("❌ Error: Recipe retrieved \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addRecipe(_ recipe: RecipeDomainModel) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            let context = containerRecipes.viewContext
            
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
            recipeDB.isCustom = recipe.isCustom
            let extraInfo: [ExtraInfo] = recipe.extraInfo.compactMap({ value in
                let item = ExtraInfo(context: context)
                item.desc = value
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
                item.url = value.url?.absoluteString ?? ""
                return item
            })
            let links: [LinkRecipe] = recipe.links.compactMap { value in
                let item = LinkRecipe(context: context)
                item.value = value?.absoluteString ?? ""
                return item
            }
            
            recipeDB.extraInfoList = NSSet(array: extraInfo)
            recipeDB.ingredientList = NSSet(array: ingredients)
            recipeDB.resourceList = NSSet(array: resources)
            recipeDB.linkList = NSSet(array: links)
            
            do {
                try context.save()
                print("✅ Success: Recipe saved")
                continuation.resume()
            } catch {
                print("❌ Error: Recipe saved \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deleteRecipe(with id: String) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            let context = containerRecipes.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                for object in result where object.identifier == id {
                    context.delete(object)
                }
                try context.save()
                print("✅ Success: Recipe deleted")
                continuation.resume()
            } catch {
                print("❌ Error: Recipe deleted \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func editRecipe(_ recipe: RecipeDomainModel) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            let context = containerRecipes.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                guard let recipeDB = result.first(where: { $0.identifier == recipe.id }) else {
                    continuation.resume(throwing: NSError())
                    return
                }
                recipeDB.desc = recipe.description
                recipeDB.isFavorite = recipe.isFavorite
                recipeDB.people = Int16(recipe.people)
                recipeDB.preparation = recipe.preparation
                recipeDB.time = recipe.time
                recipeDB.timestamp = recipe.dateUpdated
                recipeDB.title = recipe.title
                recipeDB.type = recipe.type
                recipeDB.isCustom = recipe.isCustom
                
                let extraInfo: [ExtraInfo] = recipe.extraInfo.compactMap({ value in
                    let item = ExtraInfo(context: context)
                    item.desc = value
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
                    item.url = value.url?.absoluteString ?? ""
                    return item
                })
                let links: [LinkRecipe] = recipe.links.compactMap { value in
                    let item = LinkRecipe(context: context)
                    item.value = value?.absoluteString
                    return item
                }
                
                recipeDB.extraInfoList = NSSet(array: extraInfo)
                recipeDB.ingredientList = NSSet(array: ingredients)
                recipeDB.resourceList = NSSet(array: resources)
                recipeDB.linkList = NSSet(array: links)
                
                try context.save()
                print("✅ Success: Recipe updated")
                continuation.resume()
            } catch {
                print("❌ Error: Recipe updated \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func setFavorite(request: RecipeFavoriteRequestDomainModel) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            let context = containerRecipes.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                guard let recipe = result.first(where: { $0.identifier == request.id }) else {
                    continuation.resume(throwing: NSError())
                    return
                }
                recipe.isFavorite = request.isFavourite
                try context.save()
                print("✅ Success: Recipe set favorite")
                continuation.resume()
            } catch {
                print("❌ Error: Recipe set favorite \(error)")
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
        let links: [LinkRecipe] = recipe.linkList?
            .allObjects as? [LinkRecipe] ?? []
        
        return RecipeDomainModel(id: recipe.identifier ?? "",
                                 title: recipe.title ?? "",
                                 type: recipe.type ?? "",
                                 description: recipe.desc ?? "",
                                 isFavorite: recipe.isFavorite,
                                 people: Int(recipe.people),
                                 preparation: recipe.preparation ?? "",
                                 dateUpdated: recipe.timestamp ?? .now,
                                 time: recipe.time,
                                 isCustom: recipe.isCustom,
                                 ingredients: parseIngredientsToDomain(ingredients),
                                 extraInfo: parseExtraInfoToDomain(extraInfo),
                                 resources: parseResourcesToDomain(resources),
                                 links: links.compactMap({ URL(string: $0.value ?? "") }))
    }
    
    private func parseIngredientsToDomain(_ ingredients: [Ingredient]) -> [IngredientDomainModel] {
        ingredients.compactMap { ingredient in
                .init(id: ingredient.identifier ?? UUID().uuidString,
                      name: ingredient.title ?? "",
                      quantity: ingredient.quantity ?? "")
        }
    }
    
    private func parseExtraInfoToDomain(_ extraInfo: [ExtraInfo]) -> [String] {
        extraInfo.compactMap { $0.desc }
    }
    
    private func parseResourcesToDomain(_ resources: [Resource]) -> [ResourceDomainModel] {
        resources.compactMap { resource in
                .init(id: resource.identifier ?? UUID().uuidString,
                      image: resource.image ?? .init(),
                      url: .init(string: resource.url ?? ""))
        }
    }
}
