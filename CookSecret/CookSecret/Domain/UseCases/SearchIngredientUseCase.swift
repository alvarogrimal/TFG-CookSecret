//
//  SearchIngredientUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

final class SearchIngredientUseCase: BaseUseCase<String, [String]> {
    
    private let httpRepository: HttpRepository
    
    init(httpRepository: HttpRepository) {
        self.httpRepository = httpRepository
    }
    
    override func handle(input: String? = nil) async throws -> [String]? {
        guard let input else { return nil }
        return try await httpRepository.searchIngredient(by: input)
    }
}
