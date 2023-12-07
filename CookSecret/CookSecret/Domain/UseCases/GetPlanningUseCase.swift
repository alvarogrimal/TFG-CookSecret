//
//  GetPlanningUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 6/12/23.
//

import Foundation

final class GetPlanningUseCase: BaseUseCase<Void, [PlanningItemDomainModel]> {
    
    private let databaseRepository: DatabaseRepository
    
    init(databaseRepository: DatabaseRepository) {
        self.databaseRepository = databaseRepository
    }
    
    override func handle(input: Void? = nil) async throws -> [PlanningItemDomainModel]? {
        try await databaseRepository.getPlanning()
    }
}
