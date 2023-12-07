//
//  CoreDataRepository+Planning.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 6/12/23.
//

import Foundation
import CoreData

extension CoreDataRepository {
    func getPlanning() async throws -> [PlanningItemDomainModel] {
        let fetchRequest: NSFetchRequest<PlannedDate> = PlannedDate.fetchRequest()
        do {
            let result = try containerPlanning.viewContext.fetch(fetchRequest)
            let recipes = try await getRecipes()
            print("✅ Success: Planning retrieved")
            
            var domainList: [PlanningItemDomainModel] = []
            
            for item in result {
                if let value = try await parseToDomain(recipes: recipes, plannedDate: item) {
                    domainList.append(value)
                }
            }
            
            return domainList
        } catch {
            print("❌ Error: Planning retrieved")
            throw error
        }
    }
    
    func setRecipes( _ recipes: [RecipeDomainModel], at date: Date) async throws {
        let context = containerPlanning.viewContext
        let fetchRequest: NSFetchRequest<PlannedDate> = PlannedDate.fetchRequest()
        do {
            let result = try containerPlanning.viewContext.fetch(fetchRequest)
            
            if let plannedDate = result.first(where: { $0.date == date }) {
                if let recipeList = plannedDate.recipes,
                   !recipeList.allObjects.isEmpty {
                    
                    var recipeIdList = recipes.compactMap({ $0.id })
                    let existingIds = Array(recipeList.allObjects).compactMap { item in
                        if let item = item as? PlannedRecipe,
                        let id = item.identifier {
                            return id
                        }
                        return nil
                    }
                    let ids = Set(recipeIdList + existingIds)
                    let plannedRecipes: [PlannedRecipe] = Array(ids).compactMap({
                        let plannedRecipe = PlannedRecipe(context: context)
                        plannedRecipe.identifier = $0
                        return plannedRecipe
                    })
                    plannedDate.recipes = NSSet(array: plannedRecipes)
                } else {
                    let recipeIds = recipes.compactMap({ $0.id })
                    plannedDate.recipes = NSSet(array: recipeIds)
                }
            } else {
                let plannedDateDB = PlannedDate(context: context)
                plannedDateDB.date = date
                let recipeList: [PlannedRecipe] = recipes.compactMap({ value in
                    let item = PlannedRecipe(context: context)
                    item.identifier = value.id
                    return item
                })
                plannedDateDB.recipes = NSSet(array: recipeList)
            }
            
            try context.save()
            print("✅ Success: Planning set recipes")
            
        } catch {
            print("❌ Error: Planning set recipes")
            throw error
        }
    }
    
    func deleteRecipe( _ recipeId: String, at date: Date) async throws {
        let context = containerPlanning.viewContext
        let fetchRequest: NSFetchRequest<PlannedDate> = PlannedDate.fetchRequest()
        do {
            let result = try containerPlanning.viewContext.fetch(fetchRequest)
            
            if let plannedDate = result.first(where: { $0.date == date }) {
                var recipes = plannedDate.recipes?.allObjects as? [PlannedRecipe]
                recipes?.removeAll(where: { $0.identifier == recipeId })
                
                if let recipeList = recipes,
                   !recipeList.isEmpty {
                    plannedDate.recipes = NSSet(array: recipeList)
                    try context.save()
                } else {
                    context.delete(plannedDate)
                }
            }
        } catch {
            print("❌ Error: Planning delete recipe from date")
            throw error
        }
    }
    
    // MARK: - Private functions
    
    func parseToDomain(recipes: [RecipeDomainModel], 
                       plannedDate: PlannedDate) async throws -> PlanningItemDomainModel? {
        
        var listLostRecipes = [String]()
        
        var recipeList: [RecipeDomainModel]? = plannedDate.recipes?.allObjects.compactMap({ recipe in
            
            if let recipe = recipe as? PlannedRecipe {
                if let firstRecipe = recipes.first(where: { $0.id == recipe.identifier }) {
                    return firstRecipe
                } else {
                    listLostRecipes.append(recipe.identifier ?? "")
                    return nil
                }
            }
            
            return nil
        })
        
        for listLostRecipe in listLostRecipes {
            try await deleteRecipe(listLostRecipe,
                                   at: plannedDate.date ?? .now)
        }
        
        guard let recipeDomainList = recipeList,
                !recipeDomainList.isEmpty else { return nil }
        return PlanningItemDomainModel(date: plannedDate.date ?? .now,
                                       recipes: recipeDomainList)
    }
}
