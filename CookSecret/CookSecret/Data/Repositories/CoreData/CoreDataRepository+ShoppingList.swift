//
//  CoreDataRepository+ShoppingList.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation
import CoreData

extension CoreDataRepository {
    
    func getShoppingList() async throws -> ShoppingListDomainModel {
        try await withCheckedThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<ShoppingIngredient> = ShoppingIngredient.fetchRequest()
            do {
                let result = try containerShoppingList.viewContext.fetch(fetchRequest)
                print("✅ Success: Shopping list retrieved")
                let domainList = result.compactMap { item in
                    parseToDomain(item: item)
                }
                continuation.resume(returning: .init(list: domainList))
            } catch {
                print("❌ Error: Shopping list retrieved")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func setCompletedValue(at id: String, value: Bool) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<ShoppingIngredient> = ShoppingIngredient.fetchRequest()
            let context = containerShoppingList.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                guard let item = result.first(where: { $0.identifier == id }) else {
                    continuation.resume(throwing: NSError())
                    return
                }
                item.completed = value
                try context.save()
                print("✅ Success: Shopping item set completed")
                continuation.resume()
            } catch {
                print("❌ Error: Shopping item set completed \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addShoppingListItem(_ item: ShoppingListItemDomainModel) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            let context = containerShoppingList.viewContext
            
            let ingredientDB = ShoppingIngredient(context: context)
            ingredientDB.identifier = item.id
            ingredientDB.name = item.name
            ingredientDB.quantity = item.quantity
            ingredientDB.completed = false
            
            do {
                try context.save()
                print("✅ Success: Shopping item saved")
                continuation.resume()
            } catch {
                print("❌ Error: Shopping item saved \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deleteShoppingListItem(_ id: String) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<ShoppingIngredient> = ShoppingIngredient.fetchRequest()
            let context = containerShoppingList.viewContext
            do {
                let result = try context.fetch(fetchRequest)
                for object in result where object.identifier == id {
                    context.delete(object)
                }
                try context.save()
                print("✅ Success: Shopping item deleted")
                continuation.resume()
            } catch {
                print("❌ Error: Shopping item deleted \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Private functions
    
    private func parseToDomain(item: ShoppingIngredient) -> ShoppingListItemDomainModel {
        .init(id: item.identifier ?? "",
              name: item.name ?? "",
              quantity: item.quantity ?? "",
              completed: item.completed)
    }
}
