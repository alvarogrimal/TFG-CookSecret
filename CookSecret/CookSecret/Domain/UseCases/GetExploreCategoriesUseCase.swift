//
//  GetExploreCategoriesUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 2/12/23.
//

import Foundation

final class GetExploreCategoriesUseCase: BaseUseCase<Void, [ExploreCategoryDomainModel]> {
    
    private let httpRepository: HttpRepository
    
    init(httpRepository: HttpRepository) {
        self.httpRepository = httpRepository
    }
    
    override func handle(input: Void? = nil) async throws -> [ExploreCategoryDomainModel]? {
        try await httpRepository.getExploreCategories()
    }
}
