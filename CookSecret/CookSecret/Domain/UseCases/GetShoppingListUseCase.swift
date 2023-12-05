//
//  GetShoppingListUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

final class GetShoppingListUseCase: BaseUseCase<Void, ShoppingListDomainModel> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: Void? = nil) async throws -> ShoppingListDomainModel? {
        try await databaseRepository.getShoppingList()
    }
}
