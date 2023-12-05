//
//  SetCompleteShoppingListItemUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

struct SetCompleteShoppingListItemUseCaseModel {
    let id: String
    let value: Bool
}

final class SetCompleteShoppingListItemUseCase: BaseUseCase<SetCompleteShoppingListItemUseCaseModel, Void> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: SetCompleteShoppingListItemUseCaseModel? = nil) async throws {
        guard let input else { return }
        try await databaseRepository.setCompletedValue(at: input.id,
                                                       value: input.value)
    }
}
