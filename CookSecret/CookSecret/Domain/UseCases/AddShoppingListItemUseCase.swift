//
//  AddShoppingListItemUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

final class AddShoppingListItemUseCase: BaseUseCase<ShoppingListItemDomainModel, Void> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: ShoppingListItemDomainModel? = nil) async throws {
        guard let input else { return }
        try await databaseRepository.addShoppingListItem(input)
    }
}
