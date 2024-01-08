//
//  GetRecipeUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 1/12/23.
//

import Foundation

final class GetRecipeUseCase: BaseUseCase<String, RecipeDomainModel> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: String? = nil) async throws -> RecipeDomainModel? {
        guard let input else { return nil }
        return try await databaseRepository.getRecipe(by: input)
    }
}
