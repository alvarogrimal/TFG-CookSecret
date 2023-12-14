//
//  CoreDataRepository.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import Foundation
import CoreData

class CoreDataRepository: NSObject, DatabaseRepository {
    
    // MARK: - Properties
    
    private static var repositoryInstance: CoreDataRepository?
    let containerShoppingList: NSPersistentCloudKitContainer!
    let containerPlanning: NSPersistentCloudKitContainer!
    
    // MARK: - Singleton
    
    static func shared() -> DatabaseRepository {
        if let repositoryInstance = CoreDataRepository.repositoryInstance {
            return repositoryInstance
        } else {
            CoreDataRepository.repositoryInstance = CoreDataRepository()
            return CoreDataRepository.repositoryInstance!
        }
    }
    
    private override init() {
        containerShoppingList = NSPersistentCloudKitContainer(name: "ShoppingList")
        containerPlanning = NSPersistentCloudKitContainer(name: "Planning")
        super.init()
        setupDatabase()
    }

    // MARK: - Private functions
    
    private func setupDatabase() {
//        containerRecipes.loadPersistentStores { (desc, error) in
//            if let error = error {
//                print("❌ Error: recipes loading store \(desc) — \(error)")
//                return
//            }
//            print("✅ Database recipes ready!")
//        }
//        
        containerShoppingList.loadPersistentStores { (desc, error) in
            if let error = error {
                print("❌ Error: shopping list loading store \(desc) — \(error)")
                return
            }
            print("✅ Database shopping list ready!")
        }
        
        containerPlanning.loadPersistentStores { (desc, error) in
            if let error = error {
                print("❌ Error: planning loading store \(desc) — \(error)")
                return
            }
            print("✅ Database planning ready!")
        }
    }
}
