//
//  AddRecipeUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import Foundation

final class AddRecipeUseCase: BaseUseCase<RecipeDomainModel, Void> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: RecipeDomainModel? = nil) async throws {
        guard let input else { return }
        try await databaseRepository.addRecipe(input)
    }
}
