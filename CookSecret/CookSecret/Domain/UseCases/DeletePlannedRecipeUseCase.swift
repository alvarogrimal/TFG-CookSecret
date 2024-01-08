//
//  DeletePlannedRecipeUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 6/12/23.
//

import Foundation

struct DeletePlannedRecipeUseCaseModel {
    let recipeId: String
    let date: Date
}

final class DeletePlannedRecipeUseCase: BaseUseCase<DeletePlannedRecipeUseCaseModel, Void> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: DeletePlannedRecipeUseCaseModel? = nil) async throws {
        guard let input else { return }
        try await databaseRepository.deleteRecipe(input.recipeId,
                                                  at: input.date)
    }
}
