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
    let container: NSPersistentContainer!
    
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
        container = NSPersistentContainer(name: "Recipe")
        super.init()
        setupDatabase()
    }

    // MARK: - Private functions
    
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("❌ Error: loading store \(desc) — \(error)")
                return
            }
            print("✅ Database ready!")
        }
    }
}
