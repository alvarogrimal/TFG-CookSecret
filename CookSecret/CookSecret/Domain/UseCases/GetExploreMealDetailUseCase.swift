//
//  GetExploreMealDetailUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 3/12/23.
//

import Foundation

final class GetExploreMealDetailUseCase: BaseUseCase<String,
                                            RecipeDomainModel> {
    
    private let httpRepository: HttpRepository
    
    init(httpRepository: HttpRepository) {
        self.httpRepository = httpRepository
    }

    override func handle(input: String? = nil) async throws -> RecipeDomainModel? {
        guard let input else { return nil }
        return try await httpRepository.getExploreMeal(by: input)
    }
}
