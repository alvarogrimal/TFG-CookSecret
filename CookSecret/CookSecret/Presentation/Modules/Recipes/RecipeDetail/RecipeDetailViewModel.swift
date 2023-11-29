//
//  RecipeDetailViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import SwiftUI

struct InfoRecipeDetailViewModel: Identifiable {
    
    enum InfoType {
        case time, people, recipeType, other
        
        func getImage() -> Image? {
            switch self {
            case .time:
                return Image.clock
            case .people:
                return Image.people
            case .recipeType:
                return Image.forkKnife
            case .other:
                return nil
            }
        }
    }
    let id: UUID
    let type: InfoType
    let value: String
}

final class RecipeDetailViewModel: BaseViewModel<RecipeCoordinatorProtocol> {
    
    // MARK: - Properties
    
    var resources: [Data]
    var title: String
    var info: [InfoRecipeDetailViewModel]
    var desc: String
    var ingredients: [RecipeIngredientViewModel]
    var preparation: String
    @Published var isFavorite: Bool
    private let recipeDomainModel: RecipeDomainModel
    
    // MARK: - Lifecycle
    
    init(recipeDomainModel: RecipeDomainModel,
         coordinator: BaseCoordinatorProtocol) {
        self.recipeDomainModel = recipeDomainModel
        resources = recipeDomainModel.resources.compactMap({ $0.image })
        title = recipeDomainModel.title
        desc = recipeDomainModel.description
        ingredients = recipeDomainModel.ingredients.compactMap({
            .init(title: $0.name, quantity: $0.quantity)
        })
        preparation = recipeDomainModel.preparation
        isFavorite = recipeDomainModel.isFavorite
        
        if recipeDomainModel.extraInfo.isEmpty {
            let people = String(format: recipeDomainModel.people == 1 ?
                                "add_recipe_person_format".localized :
                                 "add_recipe_people_format".localized,
                                recipeDomainModel.people)
            info = [
                .init(id: UUID(), 
                      type: .time,
                      value: Utils.getShortTime(from: recipeDomainModel.time)),
                .init(id: UUID(),
                      type: .people,
                      value: people),
                .init(id: UUID(),
                      type: .recipeType,
                      value: RecipeType(rawValue: recipeDomainModel.type ?? "")?.getValue() ?? "")
            ]
        } else {
            info = recipeDomainModel.extraInfo.compactMap({
                .init(id: UUID(), type: .other, value: $0.description)
            })
        }
        super.init(coordinator: coordinator)
    }
    
    // MARK: - Internal funtions
    
}

// MARK: - Mock

extension RecipeDetailViewModel {
    static let sample: RecipeDetailViewModel = {
        .init(recipeDomainModel: .init(title: "",
                                       description: "",
                                       people: .zero,
                                       preparation: "",
                                       dateUpdated: .now,
                                       time: .zero,
                                       ingredients: [],
                                       extraInfo: [],
                                       resources: []),
              coordinator: RecipeCoordinator.sample)
    }()
}
