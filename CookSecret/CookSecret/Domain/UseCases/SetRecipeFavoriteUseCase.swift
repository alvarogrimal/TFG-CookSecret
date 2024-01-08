//
//  SetRecipeFavoriteUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 30/11/23.
//

import Foundation

final class SetRecipeFavouriteUseCase: BaseUseCase<RecipeFavoriteRequestDomainModel, Void> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: RecipeFavoriteRequestDomainModel? = nil) async throws {
        guard let input else { return }
        try await databaseRepository.setFavorite(request: input)
    }
}
