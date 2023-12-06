//
//  SetPlannedRecipesUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 6/12/23.
//

import Foundation

struct SetPlannedRecipesUseCaseModel {
    let recipes: [RecipeDomainModel]
    let date: Date
}

final class SetPlannedRecipesUseCase: BaseUseCase<SetPlannedRecipesUseCaseModel, Void> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: SetPlannedRecipesUseCaseModel? = nil) async throws {
        guard let input else { return }
        try await databaseRepository.setRecipes(input.recipes,
                                                at: input.date)
    }
}
