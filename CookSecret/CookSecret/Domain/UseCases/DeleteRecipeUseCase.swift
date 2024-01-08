//
//  DeleteRecipeUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 30/11/23.
//

import Foundation

final class DeleteRecipeUseCase: BaseUseCase<String, Void> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: String? = nil) async throws {
        guard let input else { return }
        try await databaseRepository.deleteRecipe(with: input)
    }
}
