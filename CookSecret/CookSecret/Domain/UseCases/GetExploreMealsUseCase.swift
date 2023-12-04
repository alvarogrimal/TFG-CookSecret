//
//  GetExploreMealsUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 2/12/23.
//

import Foundation

final class GetExploreMealsUseCase: BaseUseCase<ExploreMealsRequestDomainModel,
                                        [ExploreMealSummaryDomainModel]> {
    
    private let httpRepository: HttpRepository
    
    init(httpRepository: HttpRepository) {
        self.httpRepository = httpRepository
    }
    
    override func handle(input: ExploreMealsRequestDomainModel? = nil) async throws -> [ExploreMealSummaryDomainModel]? {
        guard let input else { return nil }
        return try await httpRepository.getExploreMeals(by: input)
    }
}
