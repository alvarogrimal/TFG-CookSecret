//
//  GetRecipesUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import Foundation

final class GetRecipesUseCase: BaseUseCase<Void, [RecipeDomainModel]> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: Void? = nil) async throws -> [RecipeDomainModel]? {
        return try await databaseRepository.getRecipes()
    }
}
